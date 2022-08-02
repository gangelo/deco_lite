# frozen_string_literal: true

RSpec.describe Deco::Model do
  subject(:deco) do
    Class.new(Deco::Model) do
    end.new(object: object, options: options)
  end

  let(:object) do
    {
      a: 'a',
      b: 'b',
      c0: {
        d: 'c0_d',
        e: {
          f: {
            g: 'c0_e_f_g'
          }
        }
      },
      c1: {
        d: 'c1_d',
        e: {
          f: {
            g: 'c1_e_f_g'
          }
        }
      }
    }
  end
  let(:attribute_names) do
    %i(a b c0_d c0_e_f_g c1_d c1_e_f_g)
    end

  let(:options) { { attrs: Deco::AttributeOptionable::MERGE } }

  describe '#initialize' do
    context 'when the arguments are valid' do
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end

      it 'responds to the correct attributes' do
        expect(attribute_names.all? do |attribute_name|
          puts "Testing respond_to? :#{attribute_name}..."
          subject.respond_to? attribute_name
        end).to eq true
      end

      it 'attributes are assigned the correct values' do
        expect(attribute_names.all? do |attribute_name|
          puts "Testing assignment of attribute :#{attribute_name}: " \
            "expected value: '#{attribute_name}', " \
            "actual value: '#{subject.public_send(attribute_name)}'"
          subject.public_send(attribute_name) == attribute_name.to_s
        end).to eq true
      end

      context 'when passing a namespace' do
        let(:options) { { namespace: :namespace } }

        it 'qualifies attribute names with the namespace' do
          expect(attribute_names.all? do |attribute_name|
            subject.respond_to? "#{options[:namespace]}_#{attribute_name}".to_sym
          end).to eq true
        end
      end
    end

    context 'when the arguments are invalid' do
      it 'raises an error'
    end
  end
end
