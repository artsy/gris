require 'spec_helper'
require 'gris/grape_extensions/crud_helpers'

describe Gris::CrudHelpers do
  before do
    @helper = SpecCrudHelper.new
  end

  it 'returns permitted_params' do
    @helper.params = { id: 1 }
    expect(@helper.permitted_params).to eq(id: 1)
  end

  it 'uses date time helpers' do
    @helper.datetime_params :created_at
    @helper.params = { message: 'hi', created_at: 1_293_901_200 }
    expected = {
      created_at: 'Sat, 01 Jan 2011 17:00:00 +0000',
      message: 'hi'
    }
    expect(@helper.permitted_params).to eq(expected)
  end
end
