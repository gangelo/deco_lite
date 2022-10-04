# frozen_string_literal: true

RSpec.describe 'DecoLite::Model features', type: :features do
  context 'when defining attributes' do
    context 'when loaded fields do not conflict with existing attributes' do
      subject do
        Class.new(DecoLite::Model) do
          attr_reader :non_existing_field

          private

          attr_writer :non_existing_field
        end.new(options: options).load!(hash: hash)
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
        end.new(options: options).load!(hash: hash)
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
        end.new(options: options).load!(hash: hash)
      end

      before do
        subject.load!(hash: { existing_field: new_value} )
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
    context 'when using #initialize to load the data' do
      subject do
        Class.new(DecoLite::Model) do
          validates :field1, :field2, :field3, presence: true

          def required_fields
            %i[field4]
          end
        end.new(hash: hash, options: options)
      end

      before do
        subject.validate
      end

      let(:hash) { { field1: :value1, field2: :value2, field3: nil } }

      it 'does not overwrite the loaded field values' do
        expect(subject.field1).to eq hash[:field1]
        expect(subject.field2).to eq hash[:field2]
        expect(subject.field3).to eq hash[:field3]
      end

      it 'validates correctly' do
        expected_errors = ["Field3 can't be blank", "Field4 field is missing"]
        expect(subject.errors.full_messages).to match_array expected_errors
      end
    end

    context 'when using #load! to load the data' do
      subject do
        Class.new(DecoLite::Model) do
          validates :field1, :field2, presence: true
        end.new(options: options).load!(hash: hash)
      end

      before do
        subject.validate
      end

      let(:hash) { { field1: :value1, field2: nil } }

      it 'validates correctly' do
        expected_errors = ["Field2 can't be blank"]
        expect(subject.errors.full_messages).to match_array expected_errors
      end
    end
  end

  describe 'when defining #required_fields' do
    subject do
      class Model < DecoLite::Model
        def required_fields
          @required_fields ||= %i[
            namespace_user_first_name
            namespace_user_last_name
            namespace_user_ssn
          ]
        end
      end
      Model.new(hash: hash, options: { namespace: :namespace })
    end

    let(:hash) do
      {
        user: {
          first_name: 'first_name'
        }
      }
    end

    context 'when the required fields take more than 1 #load! to load' do
      before do
        subject
      end

      it 'fails validation until the reqired fields load' do
        expect(subject.valid?).to eq false

        subject.load!(hash: { user: { last_name: 'last_name' } })
        expect(subject.valid?).to eq false

        subject.load!(hash: { user: { ssn: 'ssn' } })
        expect(subject.valid?).to eq true
      end
    end
  end
end
