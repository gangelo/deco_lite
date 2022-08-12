# frozen_string_literal: true

RSpec.describe 'Deco::Model features', type: :features do
  context 'when defining attributes' do
    context 'when loaded fields do not conflict with existing attributes' do
      subject do
        Class.new(Deco::Model) do
          attr_reader :non_existing_field

          private

          attr_writer :non_existing_field
        end.new(options: options).load(hash: hash)
      end

      it 'retains the field reader/writer methods' do
        expect(subject).to respond_to :non_existing_field
        expect(subject.private_methods).to include :non_existing_field=
      end
    end

    context 'when loading fields conflict with existing attributes' do
      subject do
        Class.new(Deco::Model) do
          attr_accessor :existing_field
        end.new(options: options).load(hash: hash)
      end

      let(:hash) { { existing_field: :existing_field } }
      let(:options) { { fields: Deco::FieldsOptionable::OPTION_FIELDS_STRICT } }
      let(:expected_error) do
        /Field 'existing_field' conflicts with existing attribute/
      end

      it_behaves_like 'an error is raised'
    end
  end

  describe 'when defining validators' do
    subject do
      Class.new(Deco::Model) do
        validates :field1, :field2, presence: true
      end.new(options: options).load(hash: hash)
    end

    before do
      subject.validate
    end

    let(:hash) { { field1: :value1, field2: nil } }

    it 'validates' do
      expected_errors = ["Field2 can't be blank"]
      expect(subject.errors.full_messages).to match_array expected_errors
    end
  end

  describe 'when defining required fields' do
    subject do
      Class.new(Deco::Model) do
        def required_fields
          %i(field1 field2)
        end
      end.new(options: options).load(hash: hash)
    end

    before do
      subject.validate
    end

    context 'when the required fields are present' do
      let(:hash) { { field1: :value1, field2: :value2 } }

      it 'returns no errors' do
        expect(subject.valid?).to eq true
      end
    end

    context 'when the required fields are missing' do
      let(:hash) { { field1: :value1 } }

      it 'returns errors' do
        expected_errors = ['Field2 field is missing']
        expect(subject.errors.full_messages).to match_array expected_errors
      end
    end
  end
end
