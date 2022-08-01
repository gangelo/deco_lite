# frozen_string_literal: true

RSpec.describe Deco::Model do
  subject(:deco) do
    Class.new(Deco::Model) do
    end.new(object: object, options: options)
  end

  let(:object) do
    {
      first_name: 'Gene',
      last_name: 'Angelo',
      address: {
        street: '123 Broadway',
        street2: 'Suite A',
        city: 'New York',
        state: 'NY',
        zip: '01234',
        residents: {
          owner: 'Gene Angelo',
          coowner: 'Elijah Angelo'
        }
      },
      address2: {
        street: '456 Hollywood Blvd.',
        street2: '',
        city: 'Hollywood',
        state: 'CA',
        zip: '56789',
        residents: {
          owner: 'Amy Angelo',
          coowner: 'Daniel Angelo'
        }
      }
    }
  end

  let(:options) { { attrs: Deco::AttributeOptionable::MERGE } }

  describe '#initialize' do
    context 'when the arguments are valid' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end

      it 'responds to the correct attributes' do
        expect(subject).to respond_to :first_name
        expect(subject).to respond_to :first_name=
        expect(subject).to respond_to :last_name
        expect(subject).to respond_to :last_name=
        expect(subject).to respond_to :address_street
        expect(subject).to respond_to :address_street=
        expect(subject).to respond_to :address_street2
        expect(subject).to respond_to :address_street2=
        expect(subject).to respond_to :address_city
        expect(subject).to respond_to :address_city=
        expect(subject).to respond_to :address_state
        expect(subject).to respond_to :address_state=
        expect(subject).to respond_to :address_zip
        expect(subject).to respond_to :address_zip=
        expect(subject).to respond_to :address_residents_owner
        expect(subject).to respond_to :address_residents_owner=
        expect(subject).to respond_to :address_residents_coowner
        expect(subject).to respond_to :address_residents_coowner=
        expect(subject).to respond_to :address2_street
        expect(subject).to respond_to :address2_street=
        expect(subject).to respond_to :address2_street2
        expect(subject).to respond_to :address2_street2=
        expect(subject).to respond_to :address2_city
        expect(subject).to respond_to :address2_city=
        expect(subject).to respond_to :address2_state
        expect(subject).to respond_to :address2_state=
        expect(subject).to respond_to :address2_zip
        expect(subject).to respond_to :address2_zip=
        expect(subject).to respond_to :address2_residents_owner
        expect(subject).to respond_to :address2_residents_owner=
        expect(subject).to respond_to :address2_residents_coowner
        expect(subject).to respond_to :address2_residents_coowner=
      end

      context 'when passing a namespace' do
        let(:options) { { namespace: :namespace } }

        it 'qualifies attribute names with the namespace' do
          namespace = options[:namespace]
          expect(subject.attribute_names.all? do |attribute_name|
            attribute_name.start_with?(namespace.to_s)
          end).to eq true
        end
      end
    end

    context 'when the arguments are invalid' do
      it 'raises an error'
    end
  end
end
