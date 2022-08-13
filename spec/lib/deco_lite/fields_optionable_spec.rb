RSpec.describe DecoLite::FieldsOptionable, type: :module do
  describe 'constants' do
    describe 'OPTION_FIELDS' do
      it_behaves_like 'a constant', :OPTION_FIELDS, :fields
    end

    describe 'OPTION_FIELDS_MERGE' do
      it_behaves_like 'a constant', :OPTION_FIELDS_MERGE, :merge
    end

    describe 'OPTION_FIELDS_STRICT' do
      it_behaves_like 'a constant', :OPTION_FIELDS_STRICT, :strict
    end

    describe 'OPTION_FIELDS_DEFAULT' do
      it_behaves_like 'a constant', :OPTION_FIELDS_DEFAULT, :merge
    end

    describe 'OPTION_FIELDS_VALUES' do
      # NOTE: This test is somewhat brittle in that it depends on the
      # array being in the correct order.
      it_behaves_like 'a constant', :OPTION_FIELDS_VALUES, [:merge, :strict]
    end
  end
end
