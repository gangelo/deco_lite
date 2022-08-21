# frozen_string_literal: true

RSpec.describe 'DecoLite::Model features', type: :features do
  context 'when defining attributes' do
    context 'when loaded fields do not conflict with existing attributes' do
      subject do
        Class.new(DecoLite::Model) do
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

    context 'when loading fields conflict with existing attributes and option fields: :strict' do
      subject do
        Class.new(DecoLite::Model) do
          attr_accessor :existing_field
        end.new(options: options).load(hash: hash)
      end

      let(:hash) { { existing_field: :existing_field } }
      let(:options) { { fields: DecoLite::FieldsOptionable::OPTION_FIELDS_STRICT } }
      let(:expected_error) do
        /Field :existing_field conflicts with existing method\(s\)/
      end

      it_behaves_like 'an error is raised'
    end

    context 'when loading fields conflict with existing attributes and option fields: :merge' do
      subject! do
        Class.new(DecoLite::Model) do
          attr_accessor :existing_field

          def initialize(options: {})
            super

            @field_names = %i(existing_field)
          end
        end.new(options: options).load(hash: hash)
      end

      before do
        subject.load(hash: { existing_field: new_value} )
      end

      let(:hash) { { existing_field: :existing_field } }
      let(:options) { { fields: DecoLite::FieldsOptionable::OPTION_FIELDS_MERGE } }
      let(:new_value) { :new_value }

      it_behaves_like 'there are no errors'

      it 'replaces the field value' do
        expect(subject.existing_field).to eq new_value
      end

      it 'does not create duplicate #field_names' do
        expect(subject.field_names).to match_array [:existing_field]
      end
    end
  end

  describe 'when defining validators' do
    subject do
      Class.new(DecoLite::Model) do
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
      Class.new(DecoLite::Model) do
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
