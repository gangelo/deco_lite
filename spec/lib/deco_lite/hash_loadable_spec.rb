RSpec.describe DecoLite::HashLoadable, type: :module do
  subject(:klass) do
    class AwesomeKlass
      include DecoLite::HashLoadable
    end.new
  end

  it 'does something awesome'
end
