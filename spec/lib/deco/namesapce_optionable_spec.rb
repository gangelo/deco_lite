RSpec.describe Deco::NamespaceOptionable, type: :module do
  describe 'constants' do
    describe '.OPTION_NAMESPACE' do
      it 'returns the option hash key' do
        expect(subject::OPTION_NAMESPACE).to eq :namespace
      end
    end

    describe '.OPTION_NAMESPACE_DEFAULT' do
      it 'returns the option default value' do
        expect(subject::OPTION_NAMESPACE_DEFAULT).to be_nil
      end
    end
  end
end
