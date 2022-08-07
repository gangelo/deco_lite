RSpec.describe Deco::Options do
  subject(:options) { described_class.new(options_hash: options_hash) }

  let(:options_hash) { nil }
  let(:default_options) { Deco::OptionsDefaultable::DEFAULT_OPTIONS }

  describe '#initialize' do
    it 'raises no errors' do
      expect { subject }.to_not raise_error
    end

    context 'when passing no arguments' do
      it 'uses the default options' do
        expect(subject.options).to eq default_options
      end
    end

    context 'when passing no arguments' do
      let(:options_hash) do
        {
          Deco::FieldsOptionable::OPTION_FIELDS =>
            Deco::FieldsOptionable::OPTION_FIELDS_VALUES
              .difference([Deco::FieldsOptionable::OPTION_FIELDS_DEFAULT]).first,
          Deco::NamespaceOptionable::OPTION_NAMESPACE =>
            "unique_#{Deco::NamespaceOptionable::OPTION_NAMESPACE_DEFAULT || 'namespace'}".to_sym,
        }
      end

      it 'copies the options passed to it' do
        expect(subject.options).to eq options_hash
      end
    end
  end
end
