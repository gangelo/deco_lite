
RSpec.shared_context 'model initialization params' do
  # Options to pass to DecoLite::Model#new by default
  let(:options) { {} }
  # Options to pass to DecoLite::Model#load by default
  let(:load_options) { {} }
  let(:default_options) { DecoLite::OptionsDefaultable::DEFAULT_OPTIONS }
  let(:fields_strict_options) do
    {
      DecoLite::FieldsOptionable::OPTION_FIELDS =>
        DecoLite::FieldsOptionable::OPTION_FIELDS_STRICT
    }
  end
  let(:fields_merge_options) do
    {
      DecoLite::FieldsOptionable::OPTION_FIELDS =>
        DecoLite::FieldsOptionable::OPTION_FIELDS_MERGE
    }
  end
  let(:non_default_options) do
    {
      DecoLite::FieldsOptionable::OPTION_FIELDS =>
        DecoLite::FieldsOptionable::OPTION_FIELDS_VALUES
          .difference([DecoLite::FieldsOptionable::OPTION_FIELDS_DEFAULT]).first,
      DecoLite::NamespaceOptionable::OPTION_NAMESPACE =>
        "unique_#{DecoLite::NamespaceOptionable::OPTION_NAMESPACE_DEFAULT || 'namespace'}".to_sym,
      DecoLite::RequiredFieldsOptionable::OPTION_REQUIRED_FIELDS =>
        DecoLite::RequiredFieldsOptionable::OPTION_REQUIRED_FIELDS_VALUES
          .difference([DecoLite::RequiredFieldsOptionable::OPTION_REQUIRED_FIELDS_DEFAULT]).first,
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
