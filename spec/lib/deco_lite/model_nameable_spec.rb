RSpec.describe DecoLite::ModelNameable, type: :module do
  subject(:klass) do
    module My
      class AwesomeKlass
        include DecoLite::ModelNameable
      end
    end
  end

  describe '.module_name' do
    it 'returns the module name' do
      expect(klass.model_name).to be_kind_of ActiveModel::Name
      expect(klass.model_name.name).to eq 'MyAwesomeKlass'
    end
  end
end
