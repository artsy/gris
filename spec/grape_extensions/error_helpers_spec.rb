require 'spec_helper'

describe Gris::ErrorHelpers do
  before do
    @helper = SpecApiErrorHelper.new
  end

  context 'gris_error!' do
    it 'returns a correctly formatted error message' do
      @helper.gris_error! 'error', 400
      expect(@helper.message)
        .to eq(message: { message: 'error', status: 400 }, status: 400)
      expect(@helper.thrown).to eq(:error)
    end
  end
end
