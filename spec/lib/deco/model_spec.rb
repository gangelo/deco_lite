# frozen_string_literal: true

RSpec.shared_examples 'the attribute values are what they should be' do
  it 'has the correct attribute values' do
    expect(attribute_names.all? do |attribute_name|
      puts "Testing assignment of attribute :#{attribute_name}: " \
        "expected value: '#{attribute_name}', " \
        "actual value: '#{subject.public_send(attribute_name)}'"
      subject.public_send(attribute_name) == attribute_name.to_s
    end).to eq true
  end
end

RSpec.shared_examples 'the attributes are defined' do
  it 'responds to the correct attributes' do
    expect(attribute_names.all? do |attribute_name|
      puts "Testing respond_to? :#{attribute_name}..."
      subject.respond_to? attribute_name
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
  let(:attribute_names) do
    %i(a b c0_d c0_e_f_g c1_d c1_e_f_g)
    end

  let(:options) { { attrs: Deco::AttributeOptionable::MERGE } }

  describe '#initialize' do
    context 'when the arguments are valid' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end

      it_behaves_like 'the attributes are defined'
      it_behaves_like 'the attribute values are what they should be'

      context 'when passing a namespace' do
        let(:options) { { namespace: :namespace } }

        it 'qualifies attribute names with the namespace' do
          expect(attribute_names.all? do |attribute_name|
            subject.respond_to? "#{options[:namespace]}_#{attribute_name}".to_sym
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

  describe '#validate_required_attributes' do
    subject(:deco) do
      Class.new(Deco::Model) do
        def initialize(object:, options:, required_attributes:)
          super(object: object, options: options)
          @required_attributes = required_attributes
        end

        def required_attributes
          @required_attributes
        end
      end.new(object: object, options: options, required_attributes: required_attributes)
    end

    before do
      subject.validate
    end

    let(:required_attributes) { [] }

    context 'when #required_attributes is blank?' do
      it_behaves_like 'there are no errors'
    end

    context 'when #required_attributes returns required attributes' do
      context 'when the required attributes exist' do
        let(:required_attributes) { attribute_names }

        it_behaves_like 'there are no errors'
      end

      context 'when the required attributes do not exist' do
        let(:required_attributes) do
          attribute_names.map { |attribute_name| "not_found_#{attribute_name}".to_sym }
        end
        let(:expected_errors) do
          [
            'Not found a attribute is missing',
            'Not found b attribute is missing',
            'Not found c0 d attribute is missing',
            'Not found c0 e f g attribute is missing',
            'Not found c1 d attribute is missing',
            'Not found c1 e f g attribute is missing'
          ]
        end

        it 'returns errors' do
          expect(subject.errors.any?).to eq true
          expect(subject.errors.full_messages).to match_array expected_errors
        end
      end
    end
  end

  describe 'when defining attributes and validators' do
    context 'when loading attributes that do not conflict with existing attributes' do
      subject(:deco) do
        Class.new(Deco::Model) do
          attr_reader :my_attribute

          private

          attr_writer :my_attribute
        end.new(object: object, options: options)
      end

      it 'retains the attribute reader/writer methods' do
        expect(subject).to respond_to :my_attribute
        expect(subject.private_methods).to include :my_attribute=
      end
    end

    context 'when loading attributes conflict with existing attributes' do
      subject(:deco) do
        Class.new(Deco::Model) do
          class << self
            def attrs
              %i(a b c0_d c0_e_f_g c1_d c1_e_f_g)
            end
          end

          attr_accessor(*attrs)

        end.new(object: object, options: options)
      end

      it_behaves_like 'the attributes are defined'
      it_behaves_like 'the attribute values are what they should be'
    end
  end
end
