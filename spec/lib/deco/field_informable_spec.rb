RSpec.describe Deco::FieldInformable, type: :module do
  subject(:klass) do
    class AwesomeKlass
      include Deco::FieldInformable
    end.new
  end

  it 'does something awesome'
end
