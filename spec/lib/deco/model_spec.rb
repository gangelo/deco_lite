# frozen_string_literal: true

RSpec.shared_examples 'the field values are what they should be' do
  it 'has the correct field values' do
    expect(field_names.all? do |field_name|
      puts "Testing assignment of field :#{field_name}: " \
        "expected value: '#{field_name}', " \
        "actual value: '#{subject.public_send(field_name)}'"
      subject.public_send(field_name) == field_name.to_s
    end).to eq true
  end
end

RSpec.shared_examples 'the fields are defined' do
  it 'responds to the correct fields' do
    expect(field_names.all? do |field_name|
      puts "Testing respond_to? :#{field_name}..."
      subject.respond_to? field_name
    end).to eq true
  end
end

RSpec.shared_examples 'an error is raised' do
  it 'raises an error' do
    expect { subject }.to raise_error expected_error
  end
end

RSpec.shared_examples 'there are no errors' do
  it 'does not return errors' do
    expect(subject.errors.any?).to eq false
  end
end

RSpec.describe Deco::Model, type: :model do
  subject(:deco) do
    Class.new(Deco::Model) do
    end.new(object: object, options: options)
  end

  let(:object) do
    {
      a: 'a',
      b: 'b',
      c0: {
        d: 'c0_d',
        e: {
          f: {
            g: 'c0_e_f_g'
          }
        }
      },
      c1: {
        d: 'c1_d',
        e: {
          f: {
            g: 'c1_e_f_g'
          }
        }
      }
    }
  end
  let(:field_names) do
    %i(a b c0_d c0_e_f_g c1_d c1_e_f_g)
    end

  let(:options) { { fields: Deco::FieldOptionable::MERGE } }

  describe '#initialize' do
    context 'when the arguments are valid' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end

      it_behaves_like 'the fields are defined'
      it_behaves_like 'the field values are what they should be'

      context 'when passing a namespace' do
        let(:options) { { namespace: :namespace } }

        it 'qualifies field names with the namespace' do
          expect(field_names.all? do |field_name|
            subject.respond_to? "#{options[:namespace]}_#{field_name}".to_sym
          end).to eq true
        end
      end
    end

    context 'when the arguments are invalid' do
      context 'when the object type is not handled' do
        let(:object) { :not_handled }
        let(:expected_error) { "object (#{object.class}) was not handled" }

        it_behaves_like 'an error is raised'
      end
    end
  end

  describe '#validate_required_fields' do
    subject(:deco) do
      Class.new(Deco::Model) do
        def initialize(object:, options:, required_fields:)
          super(object: object, options: options)
          @required_fields = required_fields
        end

        def required_fields
          @required_fields
        end
      end.new(object: object, options: options, required_fields: required_fields)
    end

    before do
      subject.validate
    end

    let(:required_fields) { [] }

    context 'when #required_fields is blank?' do
      it_behaves_like 'there are no errors'
    end

    context 'when #required_fields is present?' do
      context 'when the required fields exist' do
        let(:required_fields) { field_names }

        it_behaves_like 'there are no errors'
      end

      context 'when the required fields do not exist' do
        let(:required_fields) do
          field_names.map { |field_name| "not_found_#{field_name}".to_sym }
        end
        let(:expected_errors) do
          [
            'Not found a field is missing',
            'Not found b field is missing',
            'Not found c0 d field is missing',
            'Not found c0 e f g field is missing',
            'Not found c1 d field is missing',
            'Not found c1 e f g field is missing'
          ]
        end

        it 'returns errors' do
          expect(subject.errors.any?).to eq true
          expect(subject.errors.full_messages).to match_array expected_errors
        end
      end
    end
  end

  describe '#field_names' do
    let(:options) { {} }

    context 'when there are no fields' do
      let(:object) { {} }

      it 'returns an empty array' do
        expect(subject.field_names).to eq []
      end
    end

    context 'when there are fields' do
      it 'returns an array of field names' do
        expect(subject.field_names).to eq field_names
      end
    end
  end

  describe 'when defining fields and validators' do
    context 'when loading fields that do not conflict with existing fields' do
      subject(:deco) do
        Class.new(Deco::Model) do
          attr_reader :my_field

          private

          attr_writer :my_field
        end.new(object: object, options: options)
      end

      it 'retains the field reader/writer methods' do
        expect(subject).to respond_to :my_field
        expect(subject.private_methods).to include :my_field=
      end
    end

    context 'when loading fields conflict with existing fields' do
      subject(:deco) do
        Class.new(Deco::Model) do
          class << self
            def fields
              %i(a b c0_d c0_e_f_g c1_d c1_e_f_g)
            end
          end

          attr_accessor(*fields)

        end.new(object: object, options: options)
      end

      it_behaves_like 'the fields are defined'
      it_behaves_like 'the field values are what they should be'
    end
  end
end
