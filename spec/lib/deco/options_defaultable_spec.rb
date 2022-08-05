RSpec.describe Deco::OptionsDefaultable, type: :module do
  let(:expected_value) do
    {
      Deco::FieldsOptionable::OPTION_FIELDS =>
        Deco::FieldsOptionable::OPTION_FIELDS_DEFAULT,
      Deco::NamespaceOptionable::OPTION_NAMESPACE =>
        Deco::NamespaceOptionable::OPTION_NAMESPACE_DEFAULT
    }
  end

  describe 'constants' do
    describe '.DEFAULT_OPTIONS' do
      it 'returns the default options' do
        expect(subject::DEFAULT_OPTIONS).to eq expected_value
      end
    end
  end
end
