RSpec.describe Deco::Optionable, type: :module do
  subject(:optionable_klass) do
    Class.new do
      include Deco::Optionable

      def initialize(options)
        @options = options
      end
    end
  end

  let(:options) { {} }
  let(:options_merge) { { attrs: Deco::AttributeOptionable::MERGE } }
  let(:options_strict) { { attrs: Deco::AttributeOptionable::STRICT } }
  let(:options_namespace) { { namespace: :namespace } }

  describe 'constants' do
    describe 'OPTIONS' do
      it 'has the expected options' do
        expect(described_class::OPTIONS).to match_array %i(attrs namespace)
      end
    end
  end

  describe 'methods' do
    subject(:optionable_object) { optionable_klass.new(options: options) }

    it 'includes the expected public methods' do
      expect(subject).to respond_to :options
      expect(subject).to respond_to :merge?
      expect(subject).to respond_to :namespace?
      expect(subject).to respond_to :strict?
      expect(subject).to respond_to :validate_options!
    end

    it 'includes the expected private methods' do
      expect(subject.private_methods).to include :options=
    end

    describe '#merge?' do
      it 'returns the correct value' do
        expect(optionable_klass.new(options_merge).merge?).to eq true
        expect(optionable_klass.new(options_strict).merge?).to eq false
        expect(optionable_klass.new({}).merge?).to eq false
      end
    end

    describe '#strict?' do
      it 'returns the correct value' do
        expect(optionable_klass.new(options_merge).strict?).to eq false
        expect(optionable_klass.new(options_strict).strict?).to eq true
        expect(optionable_klass.new({}).strict?).to eq false
      end
    end

    describe '#namespace?' do
      it 'returns the correct value' do
        expect(optionable_klass.new(options_namespace).namespace?).to eq true
        expect(optionable_klass.new(options_strict).namespace?).to eq false
        expect(optionable_klass.new({}).namespace?).to eq false
      end
    end
  end
end
