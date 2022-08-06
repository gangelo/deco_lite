RSpec.describe Deco::FieldInformable, type: :module do
  include_context 'loadable objects'

  subject(:klass) do
    Class.new do
      include Deco::FieldInformable

      def test_field_info_from(hash:, namespace: [])
        field_info_from(hash: hash, namespace: namespace)
      end

      def test_add_field_info_to(field_info:, key:, namespace:)
        add_field_info_to(field_info: field_info, key: key, namespace: namespace)
      end
    end.new
  end

  let(:namespace) { nil }

  describe '#field_info_from' do
    context 'with no namespace' do
      it 'returns the correct field info' do
        field_info = subject.test_field_info_from(hash: loadable_hash, namespace: namespace)
        expect(field_info).to eq loadable_hash_field_info
      end
    end

    context 'with a namespace' do
      before do
        old_key = loadable_hash_field_info.keys.first
        new_key = "#{namespace}_#{old_key}".to_sym
        loadable_hash_field_info[new_key] = loadable_hash_field_info.delete old_key
      end

      let(:namespace) { :namespace }
      it 'returns the correct field info' do
        field_info = subject.test_field_info_from(hash: loadable_hash, namespace: namespace)
        expect(field_info).to eq loadable_hash_field_info
      end
    end
  end

  describe '#add_field_info_to' do
  end
end
