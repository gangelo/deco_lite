# frozen_string_literal: true

RSpec.describe DecoLite::Model, type: :model do
  describe '#initialize' do
    context 'with no options' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with valid options' do
      subject { described_class.new(options: default_options) }

      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end
    end
  end

  describe '#load' do
    subject do
      described_class.new(options: options)
        .load(hash: hash, options: load_options)
    end

    context 'when the arguments are valid' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end

      it_behaves_like 'the fields are defined'
      it_behaves_like 'the field values are what they should be'

      context 'when passing a namespace' do
        let(:load_options) { { namespace: :namespace } }
        let(:namespace) { load_options[:namespace] }

        it 'creates the fields using the namespace' do
          expect(field_names.all? do |field_name|
            subject.respond_to? "#{namespace}_#{field_name}".to_sym
          end).to eq true
        end

        it 'assigns the correct value' do
          expect(field_names.all? do |field_name|
            namespaced_field_name = "#{namespace}_#{field_name}".to_sym
            subject.public_send(namespaced_field_name) == field_name
          end).to eq true
        end
      end
    end

    context 'when the arguments are invalid' do
      context 'when the object type is not handled' do
        let(:hash) { :not_handled }
        let(:expected_error) { "Argument hash is not a Hash (#{hash.class})" }

        it_behaves_like 'an error is raised'
      end
    end
  end

  describe '#validate_required_fields' do
    subject do
      Class.new(DecoLite::Model) do
        def initialize(hash:, options:, required_fields:)
          super(options: options)
          @required_fields = required_fields
        end

        def required_fields
          @required_fields
        end
      end.new(hash: hash, options: options, required_fields: required_fields)
        .load(hash: hash)
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
    subject do
      described_class.new(options: options)
        .load(hash: hash, options: load_options)
    end

    context 'when there are no fields' do
      let(:hash) { {} }

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
end
