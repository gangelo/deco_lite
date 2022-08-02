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
  let(:attribute_names) do
    %i(first_name
      first_name=
      last_name
      last_name=
      address_street
      address_street=
      address_street2
      address_street2=
      address_city
      address_city=
      address_state
      address_state=
      address_zip
      address_zip=
      address_residents_owner
      address_residents_owner=
      address_residents_coowner
      address_residents_coowner=
      address2_street
      address2_street=
      address2_street2
      address2_street2=
      address2_city
      address2_city=
      address2_state
      address2_state=
      address2_zip
      address2_zip=
      address2_residents_owner
      address2_residents_owner=
      address2_residents_coowner
      address2_residents_coowner=)
    end

  let(:options) { { attrs: Deco::AttributeOptionable::MERGE } }

  describe '#initialize' do
    context 'when the arguments are valid' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end

      it 'responds to the correct attributes' do
        expect(attribute_names.all? do |attribute_name|
          subject.respond_to? attribute_name
        end).to eq true
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
