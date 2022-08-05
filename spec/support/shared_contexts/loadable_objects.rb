
RSpec.shared_context 'loadable objects' do
  let(:loadable_hash) do
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
  let(:loadable_hash_field_info) do
    {
      a_b_c_field: { field_name: :field, dig: %i(a b c) }
    }
  end
end

RSpec.configure do |config|
  config.include_context 'loadable objects'
end
