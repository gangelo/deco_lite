RSpec.describe Deco::FieldInformable, type: :module do
  include_context 'loadable objects'

  subject(:klass) do
    Class.new do
      include Deco::FieldInformable

      def test_field_info_from(hash:, namespace: [])
        get_field_info(hash: hash, namespace: namespace)
      end

      def test_add_field_info_to(field_info:, key:, namespace:, dig:)
        set_field_info!(field_info: field_info,
                          key: key,
                          namespace: namespace,
                          dig: dig)
      end
    end.new
  end

  let(:namespace) { nil }

  describe '#get_field_info' do
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

  describe '#set_field_info!' do
    before do
      subject.test_add_field_info_to(field_info: field_info,
                                     key: :field_name,
                                     namespace: :namespace,
                                     dig: [:dig])
    end

    let(:field_info) { {} }
    let(:expected_field_info) do
      {
        namespace_dig_field_name:
          {
            field_name: :field_name,
            dig: [:dig]
          }
      }
    end
    it 'adds the field info to #field_info array' do
      expect(field_info).to eq expected_field_info
    end
  end
end
