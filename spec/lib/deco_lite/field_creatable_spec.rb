RSpec.describe DecoLite::FieldCreatable, type: :module do
  subject(:klass) do
    class AwesomeKlass
      include DecoLite::FieldAssignable
      include DecoLite::FieldCreatable
      include DecoLite::FieldNamesPersistable
    end.new
  end

  let(:field_name) { :field_name }
  let(:field_names) { %i(field_name_a field_name_b) }
  let(:options) { DecoLite::Options.default }

  describe '#create_field_accessors' do
    context 'when passing a blank? array' do
      it 'does not raise an error' do
        expect { klass.create_field_accessors field_names: field_names, options: options }.to_not raise_error
      end
    end

    context 'when passing an array of field names' do
      before do
        klass.create_field_accessors field_names: field_names, options: options
      end

      it 'creates the attr_accessor' do
        expect(field_names.all? do |field_name|
          klass.respond_to?(field_name) && klass.respond_to?("#{field_name}=".to_sym)
        end).to eq true
      end
    end
  end
end
