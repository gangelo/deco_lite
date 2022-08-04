RSpec.describe Deco::FieldRequireable, type: :module do
  subject(:klass) do
    Klass = Class.new do
      include ActiveModel::Model
      include Deco::FieldCreatable
      include Deco::FieldRequireable

      def initialize(field_names:)
        create_field_accessors field_names: field_names
      end
    end
    Klass.new(field_names: field_names)
  end

  describe '#required_fields' do
    let(:field_names) { [] }

    it 'returns an empty array' do
      expect(klass.required_fields).to eq []
    end
  end

  describe '#validate_required_fields' do
    let(:field_names) { %i(field_a field_b) }

    context 'when the field_names all have attr_accessors' do
      before do
        klass.validate_required_fields
      end

      it 'no errors are present' do
        expect(klass.errors.any?).to eq false
      end
    end

    context 'when the field_names do not have attr_accessors' do
      before do
        allow(klass).to receive(:required_fields).and_return(%i(not_found_a not_found_b))
        klass.validate_required_fields
      end

      let(:expected_errors) do
        [
          'Not found a field is missing',
          'Not found b field is missing'
        ]
      end

      it 'errors are present' do
        expect(klass.errors.full_messages).to match_array expected_errors
      end
    end
  end
end
