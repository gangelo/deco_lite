RSpec.describe Deco::Optionable, type: :module do
  subject(:optionable_klass) do
    Class.new do
      include Deco::Optionable

      def initialize(options)
        @options = options
      end
    end
  end

  let(:options) { {} }
  let(:options_merge) { { fields: Deco::FieldsOptionable::OPTION_FIELDS_MERGE } }
  let(:options_strict) { { fields: Deco::FieldsOptionable::OPTION_FIELDS_STRICT } }
  let(:options_namespace) { { namespace: :namespace } }

  describe 'constants' do
    describe 'OPTIONS' do
      it 'has the expected options' do
        expect(Deco::OptionsValidatable::OPTIONS).to match_array %i(fields namespace)
      end
    end

    describe 'OPTION_FIELDS_VALUES' do
      it 'has the expected options' do
        expected_array = [Deco::FieldsOptionable::OPTION_FIELDS_MERGE, Deco::FieldsOptionable::OPTION_FIELDS_STRICT]
        expect(described_class::OPTION_FIELDS_VALUES).to match_array expected_array
      end
    end
  end

  describe 'methods' do
    subject(:optionable_object) { optionable_klass.new(options: options) }

    it 'includes the expected public methods' do
      expect(subject).to respond_to :merge?
      expect(subject).to respond_to :namespace?
      expect(subject).to respond_to :strict?
      expect(subject).to respond_to :validate_options!
    end

    it 'includes the expected private methods' do
      expect(subject.private_methods).to include :options=
    end

    describe '#field' do
      context 'when not set' do
        it 'returns the default value' do
          expect(optionable_klass.new(options).field).to eq Deco::FieldsOptionable::OPTION_FIELDS_DEFAULT
        end
      end
    end

    describe '#namespace' do
      context 'when set' do
        it 'returns the value' do
          namespace = options_namespace[:namespace]
          expect(optionable_klass.new(options_namespace).namespace).to eq namespace
        end
      end

      context 'when not set' do
        it 'returns nil' do
          expect(optionable_klass.new(options).namespace).to be_nil
        end
      end
    end

    describe '#merge?' do
      it 'returns the correct value' do
        expect(optionable_klass.new(options_merge).merge?).to eq true
        expect(optionable_klass.new(options_strict).merge?).to eq false
      end

      context 'when nil' do
        it 'returns the default merge value' do
          expect(optionable_klass.new(options).field).to eq Deco::FieldsOptionable::OPTION_FIELDS_DEFAULT
        end
      end
    end

    describe '#strict?' do
      it 'returns the correct value' do
        expect(optionable_klass.new(options_merge).strict?).to eq false
        expect(optionable_klass.new(options_strict).strict?).to eq true
      end
    end

    describe '#namespace?' do
      it 'returns the correct value' do
        expect(optionable_klass.new(options_namespace).namespace?).to eq true
        expect(optionable_klass.new(options_strict).namespace?).to eq false
        expect(optionable_klass.new({}).namespace?).to eq false
      end
    end

    describe '#validate_options!' do
      context 'with valid option keys' do
        let(:options) { options_namespace.merge(options_merge) }

        it 'does not raise an error' do
          expect { optionable_klass.new(options).validate_options! }.to_not raise_error
        end
      end

      context 'with invalid option keys' do
        let(:options) do
          options_namespace.merge(options_merge)
                           .merge({ in: 'bad', valid: false, options: 100 })
        end
        let(:expected_error) do
          'One or more options were unrecognized: ' \
            "#{options.except(*Deco::OptionsValidatable::OPTIONS)&.keys}"
        end

        it 'raises an error' do
          expect { optionable_klass.new(options).validate_options! }.to raise_error expected_error
        end
      end

      context 'with invalid option values' do
        context 'when option :fields is the wrong type' do
          it 'raises an error' do
            expect do
              optionable_klass.new({ fields: 'wrong type' }).validate_options!
            end.to raise_error(/option :fields value or type is invalid/)
          end
        end

        context 'when option :fields is the wrong value' do
          it 'raises an error' do
            expect do
              optionable_klass.new({ fields: :wrong_value }).validate_options!
            end.to raise_error(/option :fields value or type is invalid/)
          end
        end

        context 'when option :namespace is the wrong type' do
          let(:options) do
            {
              fields: Deco::FieldsOptionable::OPTION_FIELDS_DEFAULT,
              namespace: 'wrong type'
            }
          end

          it 'raises an error' do
            expect do
              optionable_klass.new(options).validate_options!
            end.to raise_error(/option :namespace value or type is invalid/)
          end
        end
      end
    end
  end
end
