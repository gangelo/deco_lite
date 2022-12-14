RSpec.describe DecoLite::Optionable, type: :module do
  subject(:optionable_klass) do
    Class.new do
      include DecoLite::Optionable

      def initialize(options)
        return if options.nil?

        self.options = options
      end
    end.new(options)
  end

  let(:options) { nil }

  describe 'attributes' do
    describe '#options' do
      it 'returns a Struct object' do
        expect(subject.options).to be_kind_of Struct
      end

      context 'when options are not assigned' do
        it 'returns the default options' do
          expect(subject.options).to eq DecoLite::Options.default
        end
      end

      context 'when options are assigned' do
        let(:options) do
          DecoLite::Options.new DecoLite::FieldsOptionable::OPTION_FIELDS =>
                            DecoLite::FieldsOptionable::OPTION_FIELDS_STRICT,
                            DecoLite::NamespaceOptionable::OPTION_NAMESPACE =>
                            :awesome_namespace
        end

        it 'returns the expected options' do
          expect(subject.options).to eq options
        end
      end
    end

    describe '#options=' do
      xit 'is private' do
        expect(subject.private_methods).to include :options=
      end
    end
  end
end
