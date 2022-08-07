RSpec.describe Deco::FieldRetrievable, type: :module do
  subject(:klass) do
    Class.new do
      include Deco::FieldRetrievable
    end.new
  end

  describe 'class methods' do
    describe '.get_field_value' do
      let(:hash) { { a: { b: { c: 'value' } } } }
      let(:field_info)  { { field_name: :c, dig:[:a, :b], namespace: nil } }

      it 'does something' do
        expect(described_class.get_field_value(hash: hash,
                                                    field_info:
                                                    field_info)).to eq 'value'
      end
    end
  end

  describe '#get_field_value' do
    it 'is private' do
      expect(subject.private_methods).to include :get_field_value
    end
  end
end
