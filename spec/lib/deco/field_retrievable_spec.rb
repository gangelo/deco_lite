RSpec.describe Deco::FieldRetrievable, type: :module do
  subject(:klass) do
    class AwesomeKlass
      include Deco::FieldRetrievable
    end.new
  end

  it 'does something awesome'
end
