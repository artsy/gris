require 'spec_helper'
require 'gris/grape_extensions/error_helpers'

describe Gris::ErrorHelpers do
  before do
    @helper = SpecApiErrorHelper.new
  end
  context 'error with text' do
    it 'does not wrap a grape error without text' do
      @helper.error!('error', 400)
      expect(@helper.message).to eq(message: 'error', status: 400)
      expect(@helper.thrown).to eq(:error)
    end
    it 'wraps a grape error with text' do
      @helper.error!('error', 400, 'text')
      expect(@helper.message).to eq(message: { error: 'error', text: 'text' }, status: 400)
      expect(@helper.thrown).to eq(:error)
    end
  end
end
