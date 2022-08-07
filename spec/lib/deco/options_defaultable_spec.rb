RSpec.describe Deco::OptionsDefaultable, type: :module do
  describe 'constants' do
    describe 'DEFAULT_OPTIONS' do
      it_behaves_like 'a constant', :DEFAULT_OPTIONS, { fields: :merge, namespace: nil }
    end
  end
end
