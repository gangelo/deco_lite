RSpec.shared_examples 'the field was created' do
  it 'responds to the field name' do
    expect(subject).to respond_to namespaced_field_name
  end
end

RSpec.describe Deco::FieldAssignable, type: :module do
  subject(:klass) do
    class AwesomeKlass
      include Deco::FieldAssignable
    end.new
  end

  let(:hash) do
    {
      a: {
        b: {
          c: {
            field: 'field data'
          }
        }
      }
    }
  end
  let(:field_info) do
    {
      a_b_c_field: { field_name: :field, namespace: %i(a b c)}
    }
  end
  let(:field_name) { field_info.first[1][:field_name] }
  let(:namespace) { field_info.first[1][:namespace] }
  let(:field_value) { hash.dig(*namespace, field_name) }
  let(:namespaced_field_name) { field_info.first[0] }

  describe '#assign_field_values' do
    before do
      subject.assign_field_values(hash: hash, field_info: field_info)
    end

    it_behaves_like 'the field was created'

    it 'creates attributes for the fields and assigns the values' do
      expect(subject.public_send(namespaced_field_name)).to eq field_value
    end
  end

  describe '#assign_field_value' do
    before do
      subject.assign_field_value(field_name: namespaced_field_name, value: field_value)
    end

    it_behaves_like 'the field was created'

    it 'creates attribute for the field and assigns the value' do
      expect(subject.public_send(namespaced_field_name)).to eq field_value
    end
  end
end
