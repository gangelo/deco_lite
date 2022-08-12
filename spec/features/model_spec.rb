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
    it 'does something awesome'
  end

  describe 'when defining fields' do
    it 'does something awesome'
  end
end
