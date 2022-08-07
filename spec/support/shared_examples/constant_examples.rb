RSpec.shared_examples 'a constant' do |const_name, const_value|
  let(:const) { const_name }
  let(:value) { const_value }

  context 'with the const defined' do
    it '.const_defined? returns true' do
      expect(described_class.const_defined? const).to eq true
    end

    it 'returns the correct value' do
      expect(described_class.const_get const).to eq value
    end
  end
end
