# frozen_string_literal: true

RSpec.describe DecoLite::Model, type: :model do
  subject do
    described_class.new(options: options)
      .load!(hash: hash, options: load_options)
  end

  describe '#initialize' do
    context 'with no options' do
      it 'does not raise an error' do
        expect { described_class.new }.to_not raise_error
      end
    end

    context 'with valid options' do
      subject do
        described_class.new(options: default_options)
          .load!(hash: hash)
      end

     it_behaves_like 'there are no errors'
    end
  end

  describe '#load!' do
    context 'when the arguments are valid' do
      it_behaves_like 'there are no errors'
      it_behaves_like 'the fields are defined'
      it_behaves_like 'the field values are what they should be'
    end

    context 'when passing a namespace' do
      subject do
        described_class.new(options: options)
          .load!(hash: hash, options: load_options)
      end
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

    context 'when the arguments are invalid' do
      context 'when the object type is not handled' do
        subject do
          described_class.new(options: options)
            .load!(hash: hash, options: load_options)
        end

        let(:hash) { :not_handled }
        let(:expected_error) { "Argument hash is not a Hash (#{hash.class})" }

        it_behaves_like 'an error is raised'
      end
    end

    describe 'when loadig objects with the same fields' do
      let(:model) do
        described_class.new(options: options)
            .load!(hash: hash, options: load_options)
      end

      it 'does not raise errors due to conflicting field names' do
        expect do
          described_class.new(options: options)
            .load!(hash: hash, options: load_options)
        end
      end

      it do
        # Sanity check to make sure the same fields were loaded.
        expect(model.to_h).to match subject.to_h
      end
    end
  end

  describe '#load' do
    subject do
      described_class.new(options: options)
        .load(hash: hash, options: load_options)
    end

    it 'raises no errors' do
      expect { subject }.to_not raise_error
    end

    it 'outputs a deprecation warning' do
      warning = 'WARNING: DecoLite::Model#load will be deprecated ' \
        'in a future release; use DecoLite::Model#load! instead!'
      expect { subject }.to output(a_string_including(warning)).to_stdout
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
        .load!(hash: hash)
    end

    before do
      subject.validate
    end

    context 'when #required_fields is blank?' do
      let(:required_fields) { [] }

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
    context 'when there are no fields' do
      let(:hash) { {} }

      it 'returns an empty array' do
        expect(subject.field_names).to eq []
      end
    end

    context 'when there are fields' do
      let!(:conflict) do
        described_class.new(options: options)
          .load!(hash: hash, options: load_options)
      end

      it 'returns an array of field names' do
        expect(subject.field_names).to eq field_names
      end
    end
  end

  describe '#to_h' do
    context 'when there are no fields' do
      let(:hash) { {} }

      it 'returns an empty Hash' do
        expect(subject.to_h).to eq({})
      end
    end

    context 'when there are fields' do
      let(:expected_hash) do
        {
          a: :a,
          b: :b,
          c0_d: :c0_d,
          c0_e_f_g: :c0_e_f_g,
          c1_d: :c1_d,
          c1_e_f_g: :c1_e_f_g
        }
      end

      it 'returns an empty Hash' do
        expect(subject.to_h).to eq expected_hash
      end
    end
  end
end
