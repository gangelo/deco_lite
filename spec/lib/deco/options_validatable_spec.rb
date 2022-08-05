RSpec.describe Deco::OptionsValidatable, type: :module do
  subject(:klass) do
    class AwesomeKlass
      include Deco::OptionsValidatable
    end.new
  end

  it 'does something awesome'
end
