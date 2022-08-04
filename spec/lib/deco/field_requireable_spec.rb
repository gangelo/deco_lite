RSpec.describe Deco::FieldRequireable, type: :module do
  subject(:klass) do
    class AwesomeKlass
      include Deco::FieldRequireable
    end.new
  end

  describe '#required_fields' do
    it 'returns an empty array' do
      expect(klass.required_fields).to eq []
    end
  end
end
