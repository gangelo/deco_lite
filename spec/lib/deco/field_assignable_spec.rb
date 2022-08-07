RSpec.shared_examples 'the field was created' do
  it 'responds to the field name' do
    expect(subject).to respond_to namespaced_field_name
  end
end

RSpec.describe Deco::FieldAssignable, type: :module do
  include_context 'loadable objects'

  subject(:klass) do
    class AwesomeKlass
      include Deco::FieldAssignable
    end.new
  end
  let(:field_name) { loadable_hash_field_info.first[1][:field_name] }
  let(:dig) { loadable_hash_field_info.first[1][:dig] }
  let(:field_value) { loadable_hash.dig(*dig, field_name) }
  let(:namespaced_field_name) { loadable_hash_field_info.first[0] }

  describe '#set_field_values' do
    before do
      subject.set_field_values(hash: loadable_hash, field_info: loadable_hash_field_info)
    end

    it_behaves_like 'the field was created'

    it 'creates attributes for the fields and assigns the values' do
      expect(subject.public_send(namespaced_field_name)).to eq field_value
    end
  end

  describe '#set_field_value' do
    before do
      subject.set_field_value(field_name: namespaced_field_name, value: field_value)
    end

    it_behaves_like 'the field was created'

    it 'creates attribute for the field and assigns the value' do
      expect(subject.public_send(namespaced_field_name)).to eq field_value
    end
  end
end
