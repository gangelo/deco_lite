RSpec.describe Deco::HashLoadable, type: :module do
  subject(:klass) do
    class AwesomeKlass
      include Deco::HashLoadable
    end.new
  end

  it 'does something awesome'
end
