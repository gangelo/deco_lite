RSpec.describe Deco::OptionsValidatable, type: :module do
  subject(:klass) do
    Class.new do
      include Deco::OptionsValidatable
    end.new.validate_options!(options: options)
  end

  let(:options) do
    {
      Deco::FieldsOptionable::OPTION_FIELDS =>
        Deco::FieldsOptionable::OPTION_FIELDS_DEFAULT,
      Deco::NamespaceOptionable::OPTION_NAMESPACE =>
        Deco::NamespaceOptionable::OPTION_NAMESPACE_DEFAULT,
    }
  end

  describe 'constants' do
    describe 'OPTIONS' do
      it_behaves_like 'a constant', :OPTIONS, [ :fields, :namespace ]
    end
  end

  describe '#validate_options!' do
    context 'when the options are valid' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end

      context 'when the :namespace option value is blank?' do
        it 'does not raise an error'
      end

      context 'when the :namespace option value is a Symbol' do
        it 'does not raise an error'
      end
    end

    context 'when the options are not valid' do
      context 'when the options argument is not a hash' do
        let(:options) { :not_a_hash }

        it 'raises an error' do
          expect { subject }.to raise_error 'options is not a Hash'
        end
      end

      context 'when the option keys are invalid' do
        let(:options) { { bad_key1: :bad, bad_key2: :worse } }

        it 'raises an error' do
          expected_error = "One or more options were unrecognized: #{options.keys}"
          expect { subject }.to raise_error expected_error
        end
      end

      context 'when the :fields option values are invalid' do
        let(:options) { { Deco::FieldsOptionable::OPTION_FIELDS => option_value } }
        let(:option_value) { :bad }

        it 'raises an error' do
          expected_error = 'option :fields value or type is invalid. ' \
            "#{Deco::FieldsOptionable::OPTION_FIELDS_VALUES} (Symbol) " \
            "was expected, but '#{option_value}' (#{option_value.class}) was received."
          expect { subject }.to raise_error expected_error
        end
      end

      context 'when the :namespace option value is invalid' do
        context 'when not a Symbol' do
          before do
            options[Deco::NamespaceOptionable::OPTION_NAMESPACE] = option_value
          end

          let(:option_value) { 'bad' }

          it 'raises an error' do
            expected_error = 'option :namespace value or type is invalid. A Symbol was expected, ' \
              "but '#{option_value}' (#{option_value.class}) was received."
            expect { subject }.to raise_error expected_error
          end
        end
      end
    end
  end
end
