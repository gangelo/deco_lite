# frozen_string_literal: true

RSpec.shared_examples 'conflicting field names are handled correctly' do
  subject do
    described_class.new(options: options)
      .load!(hash: hash, options: fields_merge_options)
  end

  let(:model) do
    described_class.new(options: options)
      .load!(hash: hash, options: load_options)
  end

  it 'does not raise an error due to conflicting field names' do
    expect { model }.to_not raise_error
  end

  it do
    # Sanity check to make sure the same fields were loaded.
    expect(hash).to_not be_empty
  end
end

RSpec.shared_examples 'conflicting field names raise an error' do
  subject do
    described_class.new(hash: hash, options: options)
  end

  it 'raises an error due to conflicting field names' do
    expect { subject.load!(hash: hash, options: load_options) }.to raise_error /conflicts with existing method\(s\)/
  end

  it do
    # Sanity check to make sure the same fields were loaded.
    expect(hash).to_not be_empty
  end
end

RSpec.shared_examples 'it loads with no errors' do
  it 'loads with no errors' do
    expect { subject }.to_not raise_error
  end
end

RSpec.describe DecoLite::Model, type: :model do
  subject do
    described_class.new(options: options)
      .load!(hash: hash, options: load_options)
  end

  describe '#initialize' do
    context 'with no arguments' do
      it 'does not raise an error' do
        expect { described_class.new }.to_not raise_error
      end
    end

    context 'with a hash' do
      subject do
        described_class.new(hash: hash, options: default_options)
      end

      it_behaves_like 'there are no errors'
      it_behaves_like 'the fields are defined'
      it_behaves_like 'the field values are what they should be'
    end

    context 'with options' do
      subject { described_class.new(options: default_options) }

     it_behaves_like 'there are no errors'
    end
  end

  describe '#load!' do
    context 'when the arguments are valid' do
      it_behaves_like 'there are no errors'
      it_behaves_like 'the fields are defined'
      it_behaves_like 'the field values are what they should be'
    end

    context 'when the arguments are invalid' do
      context 'when the object type is not handled' do
        subject do
          described_class.new(options: options)
            .load!(hash: hash, options: load_options)
        end

        let(:hash) { :not_handled }
        let(:expected_error) { "Argument hash is not a Hash (#{hash.class})" }

        it_behaves_like 'an error is raised'
      end
    end

    context 'when passing a namespace' do
      subject do
        described_class.new(options: options)
          .load!(hash: hash, options: load_options)
      end
      let(:load_options) { { namespace: :namespace } }
      let(:namespace) { load_options[:namespace] }

      it 'creates the fields using the namespace' do
        expect(field_names.all? do |field_name|
          subject.respond_to? "#{namespace}_#{field_name}".to_sym
        end).to eq true
      end

      it 'assigns the correct value' do
        expect(field_names.all? do |field_name|
          namespaced_field_name = "#{namespace}_#{field_name}".to_sym
          subject.public_send(namespaced_field_name) == field_name
        end).to eq true
      end
    end

    describe 'when loading objects with the conflicting field names' do
      context 'when using the default options' do
        it_behaves_like 'conflicting field names are handled correctly'
      end

      context 'when options allow field merging' do
        context 'with no namespace' do
          let(:load_options) { fields_merge_options }

          it_behaves_like 'conflicting field names are handled correctly'
        end

        context 'with a namespace' do
          let(:load_options) { fields_merge_options.merge({ namespace: :namespace }) }

          it_behaves_like 'conflicting field names are handled correctly'
        end
      end

      context 'when options are strict (do not allow field merging)' do
        context 'with no namespace' do
          let(:load_options) { fields_strict_options }

          it_behaves_like 'conflicting field names raise an error'
        end

        context 'with a namespace' do
          let(:load_options) { fields_strict_options.merge({ namespace: :namespace }) }

          it_behaves_like 'conflicting field names are handled correctly'
        end
      end
    end
  end

  describe '#validate' do
    context 'when ActiveModel validators are defined' do
      subject(:model) do
        Klass = Class.new(DecoLite::Model) do
          validates :a, :b, presence: true
        end
        Klass.new(hash: hash)
      end

      context 'before any data is loaded' do
        let(:hash) { {} }
        let(:expected_errors) do
          [
            "A can't be blank",
            "B can't be blank"
          ]
        end

        it 'validates the model without raising errors' do
          expect(subject.valid?).to eq false
          expect(subject.errors.full_messages).to match_array expected_errors
        end
      end

      context 'after data is loaded' do
        before do
          subject.load!(hash: { a: :a, b: :b })
        end

        it 'validates the model without raising errors' do
          expect(subject.valid?).to eq true
        end
      end
    end
  end

  describe '#field_names' do
    context 'when there are no fields' do
      let(:hash) { {} }

      it 'returns an empty array' do
        expect(subject.field_names).to eq []
      end
    end

    context 'when there are fields' do
      let!(:conflict) do
        described_class.new(options: options)
          .load!(hash: hash, options: load_options)
      end

      it 'returns an array of field names' do
        expect(subject.field_names).to eq field_names
      end
    end
  end

  describe '#to_h' do
    context 'when there are no fields' do
      let(:hash) { {} }

      it 'returns an empty Hash' do
        expect(subject.to_h).to eq({})
      end
    end

    context 'when there are fields' do
      let(:expected_hash) do
        {
          a: :a,
          b: :b,
          c0_d: :c0_d,
          c0_e_f_g: :c0_e_f_g,
          c1_d: :c1_d,
          c1_e_f_g: :c1_e_f_g
        }
      end

      it 'returns an empty Hash' do
        expect(subject.to_h).to eq expected_hash
      end
    end
  end

  describe '#required_fields' do
    subject do
      class Model < DecoLite::Model
        def required_fields
          @required_fields ||= %i[
            user_first_name
            user_last_name
            user_ssn
          ]
        end
      end
      Model.new(hash: hash)
    end

    context 'when there are required fields' do
      context 'when all the required fields are loaded' do
        let(:hash) do
          {
            user: {
              first_name: 'first_name',
              last_name: 'last_name',
              ssn: '123456789'
            }
          }
        end

        it_behaves_like 'it loads with no errors'

        it 'passes validation' do
          expect(subject.valid?).to eq true
        end
      end

      context 'when some of the required fields are loaded' do
        let(:hash) do
          {
            user: {
              xfirst_name: 'xfirst_name',
              last_name: 'last_name',
              ssn: '123456789'
            }
          }
        end

        it_behaves_like 'it loads with no errors'

        it 'fails validation' do
          expect(subject.valid?).to eq false
        end
      end

      context 'when none of the required fields are loaded' do
        let(:hash) do
          {
            xuser: {
              first_name: 'first_name',
              last_name: 'last_name',
              ssn: '123456789'
            }
          }
        end

        it_behaves_like 'it loads with no errors'

        it 'fails validation' do
          expect(subject.valid?).to eq false
        end
      end
    end
  end
end
