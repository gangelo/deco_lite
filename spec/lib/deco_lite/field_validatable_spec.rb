RSpec.shared_examples 'the field_name is valid' do |field_name, options|
  it 'does not raise an error' do
    expect do
      subject.validate_field_name!(field_name: field_name, options: options)
    end.to_not raise_error
  end
end

RSpec.shared_examples 'the field_name is invalid' do |field_name, options|
  it 'raises an error' do
    expect do
      subject.validate_field_name!(field_name: field_name, options: options)
    end.to raise_error "field_name '#{field_name}' is not a valid field name."
  end
end

RSpec.describe DecoLite::FieldValidatable, type: :module do
  subject { described_class }

  let(:options) { DecoLite::Options.default }

  context 'when the field_name is valid' do
    it_behaves_like 'the field_name is valid', :some_field
    it_behaves_like 'the field_name is valid', 'some_field'
  end

  context 'when the field_name is invalid' do
    it_behaves_like 'the field_name is invalid', :'some_field===='
    it_behaves_like 'the field_name is invalid', 'some field'
  end
end
