RSpec.describe DecoLite::FieldAssignable, type: :module do
  include_context 'loadable objects'

  describe '#set_field_value' do
    subject(:klass) do
      Class.new do
        include DecoLite::FieldAssignable
        include DecoLite::FieldCreatable
        include DecoLite::FieldNamesPersistable

        def initialize(field_name, options)
          create_field_accessor(field_name: field_name, options: options)
        end
      end.new(field_name, options)
    end

    let(:field_name) { :field_name }
    let(:field_value) { :field_value }
    let(:options) { DecoLite::Options.default }

    before do
      subject.set_field_value(field_name: field_name, value: field_value, options: options)
    end

    it 'assigns the field value' do
      expect(subject.public_send(field_name)).to eq field_value
    end
  end

  describe '#set_field_values' do
    context 'when the field is not namespaced' do
      subject(:klass) do
        Class.new do
          include DecoLite::FieldAssignable
          include DecoLite::FieldCreatable
          include DecoLite::FieldNamesPersistable

          def initialize(loadable_hash, options)
            loadable_hash.keys.each do |field_name|
              create_field_accessor(field_name: field_name, options: options)
            end
          end
        end.new(loadable_hash, options)
      end

      let(:loadable_hash) do
        {
          field0: 'field0 data',
          field1: 'field1 data',
          field2: 'field2 data'
        }
      end
      let(:loadable_hash_field_info) do
        {
          field0: { field_name: :field0, dig: [] },
          field1: { field_name: :field1, dig: [] },
          field2: { field_name: :field2, dig: [] }
        }
      end
      let(:field_name) { :field_name }
      let(:field_value) { :field_value }
      let(:options) { DecoLite::Options.default }

      before do
        subject.set_field_values(hash: loadable_hash, field_info: loadable_hash_field_info, options: options)
      end

      it 'assigns the field values' do
        loadable_hash.each do |field_name, field_value|
          expect(subject.public_send(field_name)).to eq field_value
        end
      end
    end

    context 'when the field is namespaced' do
      subject(:klass) do
        Class.new do
          include DecoLite::FieldAssignable
          include DecoLite::FieldCreatable
          include DecoLite::FieldNamesPersistable

          def initialize(field_name, options)
            create_field_accessor(field_name: field_name, options: options)
          end
        end.new(namespaced_field_name, options)
      end

      let(:field_name) { loadable_hash_field_info.first[1][:field_name] }
      let(:dig) { loadable_hash_field_info.first[1][:dig] }
      let(:field_value) { loadable_hash.dig(*dig, field_name) }
      let(:namespaced_field_name) { loadable_hash_field_info.first[0] }
      let(:options) { DecoLite::Options.default }

      before do
        subject.set_field_values(hash: loadable_hash, field_info: loadable_hash_field_info, options: options)
      end

      it 'assigns the field value' do
        expect(subject.public_send(namespaced_field_name)).to eq field_value
      end
    end
  end
end
