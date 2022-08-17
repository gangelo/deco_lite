RSpec.describe DecoLite::Options, type: :module do
  subject { described_class.new(**options) }

  let(:options) { DecoLite::OptionsDefaultable::DEFAULT_OPTIONS }

  describe 'class methods' do
    describe '#new' do
      context 'when options are valid' do
        it 'raises no errors' do
          expect { subject }.to_not raise_error
        end
      end

      context 'when an option key is invalid' do
        let(:options) { { invalid_fields_key: :merge, invalid_namespace_key: :namespace } }

        it 'raises no errors' do
          expected_error = 'One or more option keys were unrecognized: [:invalid_fields_key, :invalid_namespace_key]'
          expect { subject }.to raise_error expected_error
        end
      end

      context 'when the :fields option key is invalid' do
        let(:options) { { invalid_fields_option_value: :merge, namespace: :namespace } }

        it 'raises no errors' do
          expected_error = 'One or more option keys were unrecognized: [:invalid_fields_option_value]'
          expect { subject }.to raise_error expected_error
        end
      end

      context 'when the :fields option value is invalid' do
        let(:options) { { fields: :invalid_fields_option_value, namespace: :namespace } }

        it 'raises no errors' do
          expected_error = "option :fields value or type is invalid. [:merge, :strict] (Symbol) was expected, but 'invalid_fields_option_value' (Symbol) was received."
          expect { subject }.to raise_error expected_error
        end
      end

      context 'when the :namespace option value is invalid' do
        let(:options) { { fields: :merge, namespace: 'invalid' } }

        it 'raises no errors' do
          expected_error = "option :namespace value or type is invalid. A Symbol was expected, but 'invalid' (String) was received."
          expect { subject }.to raise_error expected_error
        end
      end
    end

    describe '#merge?' do
      context 'when option fields: is :merge' do
        let(:options) { { fields: :merge } }

        it 'returns true' do
          expect(subject.merge?).to eq true
        end
      end

      context 'when option fields: is not :merge' do
        let(:options) { { fields: :strict } }

        it 'returns false' do
          expect(subject.merge?).to eq false
        end
      end
    end

    describe '#strict?' do
      context 'when option fields: is :strict' do
        let(:options) { { fields: :strict } }

        it 'returns true' do
          expect(subject.strict?).to eq true
        end
      end

      context 'when option fields: is not :strict' do
        let(:options) { { fields: :merge } }

        it 'returns false' do
          expect(subject.strict?).to eq false
        end
      end
    end

    describe '#namespace?' do
      context 'when option namespace: is a Symbol' do
        let(:options) { { fields: :merge, namespace: :namespace } }

        it 'returns true' do
          expect(subject.namespace?).to eq true
        end
      end

      context 'when option namespace: is nil?' do
        let(:options) { { fields: :merge, namespace: nil } }

        it 'returns false' do
          expect(subject.namespace?).to eq false
        end
      end
    end
  end
end
