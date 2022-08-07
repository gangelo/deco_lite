RSpec.describe Deco::NamespaceOptionable, type: :module do
  describe 'constants' do
    describe 'OPTION_NAMESPACE' do
      it_behaves_like 'a constant', :OPTION_NAMESPACE, :namespace
    end

    describe 'OPTION_NAMESPACE_DEFAULT' do
      it_behaves_like 'a constant', :OPTION_NAMESPACE_DEFAULT, nil
    end
  end
end
