RSpec.shared_examples 'the field values are what they should be' do
  it 'has the correct field values' do
    expect(subject.field_names).to be_present
    expect(subject.field_names.all? do |field_name|
      puts "Testing assignment of field :#{field_name} >>> " \
        "expected value: '#{field_name}', " \
        "actual value: '#{subject.public_send(field_name)}'"
      subject.public_send(field_name) == field_name
    end).to eq true
  end
end

RSpec.shared_examples 'the fields are defined' do
  it 'responds to the correct fields' do
    expect(subject.field_names).to be_present
    expect(subject.field_names.all? do |field_name|
      puts "Testing respond_to? :#{field_name}..."
      subject.respond_to? field_name
    end).to eq true
  end
end

RSpec.shared_examples 'an error is raised' do
  it 'raises an error' do
    expect do
      subject.load(hash: hash, options: load_options)
    end.to raise_error expected_error
  end
end

RSpec.shared_examples 'there are no errors' do
  it 'does not return errors' do
    subject.validate
    expect(subject.errors.any?).to eq false
  end
end
