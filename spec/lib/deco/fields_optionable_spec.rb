RSpec.describe Deco::FieldsOptionable, type: :module do
  subject(:klass) do
    class AwesomeKlass
      include Deco::FieldsOptionable
    end.new
  end

  it 'does something awesome'
end
