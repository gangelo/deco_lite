RSpec.shared_examples 'no errors are raised' do
  it 'does not raise an error' do
    expect { subject }.to_not raise_error
  end
end

RSpec.shared_examples 'option :fields raises an error' do
  before do
    options[DecoLite::FieldsOptionable::OPTION_FIELDS] = option_value
  end

  it 'raises an error' do
    expected_error = 'option :fields value or type is invalid. ' \
      "#{DecoLite::FieldsOptionable::OPTION_FIELDS_VALUES} (Symbol) " \
      "was expected, but '#{option_value}' (#{option_value.class}) was received."
    expect { subject }.to raise_error expected_error
  end
end

RSpec.shared_examples 'option :namespace raises an error' do
  before do
    options[DecoLite::NamespaceOptionable::OPTION_NAMESPACE] = option_value
  end

  it 'raises an error' do
    expected_error = 'option :namespace value or type is invalid. A Symbol was expected, ' \
      "but '#{option_value}' (#{option_value.class}) was received."
    expect { subject }.to raise_error expected_error
  end
end

RSpec.describe DecoLite::OptionsValidatable, type: :module do
  subject(:klass) do
    Class.new do
      include DecoLite::OptionsValidatable
    end.new.validate_options!(options: options)
  end

  let(:options) { default_options.dup }

  describe 'constants' do
    describe 'OPTIONS' do
      it_behaves_like 'a constant', :OPTIONS, [:fields, :namespace]
    end
  end

  describe '#validate_options!' do
    context 'when the options are valid' do
      subject(:klass) do
        Class.new do
          include DecoLite::OptionsValidatable
        end.new
      end

      context ':fields' do
        let(:option_values) { DecoLite::FieldsOptionable::OPTION_FIELDS_VALUES }

        it 'does not raise an error' do
          expect do
            option_values.each do |option_value|
              options[DecoLite::FieldsOptionable::OPTION_FIELDS] = option_value
              subject.validate_options!(options: options)
            end
          end.to_not raise_error
        end
      end

      context ':namespace' do
        context 'when blank?' do
          let(:options) do
            new_options = default_options.dup
            new_options[DecoLite::NamespaceOptionable::OPTION_NAMESPACE] = nil
            new_options
          end

          it_behaves_like 'no errors are raised'
        end

        context 'when any Symbol' do
          context 'when any Symbol' do
            let(:option_values) { %i(any symbol is works) }

            it 'does not raise an error' do
              expect do
                option_values.each do |namespace|
                  options[DecoLite::NamespaceOptionable::OPTION_NAMESPACE] = namespace
                  subject.validate_options!(options: options)
                end
              end.to_not raise_error
            end
          end
        end
      end
    end

    context 'when the options are invalid' do
      context 'when the options argument is not a hash' do
        let(:options) { :not_a_hash }

        it 'raises an error' do
          expect { subject }.to raise_error 'options is not a Hash'
        end
      end

      context 'when the option keys are invalid' do
        let(:options) { { bad_key1: :bad, bad_key2: :worse } }

        it 'raises an error' do
          expected_error = "One or more option keys were unrecognized: #{options.keys}"
          expect { subject }.to raise_error expected_error
        end
      end

      context 'when the :fields option values are invalid' do
        let(:option_value) { :bad }

        it_behaves_like 'option :fields raises an error'
      end

      context 'when the :namespace option value is invalid' do
        context 'when not a Symbol' do
          let(:option_value) { 'bad' }

          it_behaves_like 'option :namespace raises an error'
        end
      end
    end
  end
end
