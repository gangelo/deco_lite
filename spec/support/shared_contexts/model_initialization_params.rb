
RSpec.shared_context 'model initialization params' do
  # Options to pass to Deco::Model#new by default
  let(:options) { {} }
  # Options to pass to Deco::Model#load by default
  let(:load_options) { {} }
  let(:default_options) { Deco::OptionsDefaultable::DEFAULT_OPTIONS }
  let(:non_default_options) do
    {
      Deco::FieldsOptionable::OPTION_FIELDS =>
        Deco::FieldsOptionable::OPTION_FIELDS_VALUES
          .difference([Deco::FieldsOptionable::OPTION_FIELDS_DEFAULT]).first,
      Deco::NamespaceOptionable::OPTION_NAMESPACE =>
        "unique_#{Deco::NamespaceOptionable::OPTION_NAMESPACE_DEFAULT || 'namespace'}".to_sym,
    }
  end
  let(:hash) do
    {
      a: :a,
      b: :b,
      c0: {
        d: :c0_d,
        e: {
          f: {
            g: :c0_e_f_g
          }
        }
      },
      c1: {
        d: :c1_d,
        e: {
          f: {
            g: :c1_e_f_g
          }
        }
      }
    }
  end
  let(:field_names) { %i(a b c0_d c0_e_f_g c1_d c1_e_f_g) }
end

RSpec.configure do |config|
  config.include_context 'model initialization params'
end
