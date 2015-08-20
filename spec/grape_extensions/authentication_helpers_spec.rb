require 'spec_helper'

describe Gris::AuthenticationHelpers do
  include_context 'with secrets from config/secrets.yml'
  context 'without permitted token' do
    before(:each) do
      @helper = SpecApiAuthHelper.new
    end

    context '#token_authentication!' do
      context 'without matching tokens' do
        it 'returns a 401 Forbidden error' do
          allow(@helper).to receive(:params).and_return(token: nil)
          allow(@helper).to receive_message_chain(:request, :headers).and_return('Http-Authorization' => nil)
          @helper.token_authentication!
          expect(@helper.message).to eq(message: 'Forbidden', status: 401)
        end
      end
      context 'with included params token' do
        it 'returns nil' do
          allow(@helper).to receive(:params).and_return(token: 'my-token')
          allow(@helper).to receive_message_chain(:request, :headers).and_return('Http-Authorization' => nil)
          expect(@helper.token_authentication!).to be_nil
        end
      end
      context 'with blank params token' do
        it 'returns a 401 Forbidden error' do
          allow(@helper).to receive(:params).and_return(token: '')
          allow(@helper).to receive_message_chain(:request, :headers).and_return('Http-Authorization' => nil)
          @helper.token_authentication!
          expect(@helper.message).to eq(message: 'Forbidden', status: 401)
        end
      end
      context 'with included request header token' do
        it 'returns nil' do
          allow(@helper).to receive(:params).and_return(token: nil)
          allow(@helper).to receive_message_chain(:request, :headers).and_return('Http-Authorization' => 'my-token')
          expect(@helper.token_authentication!).to be_nil
        end
      end
      context 'with blank header token' do
        it 'returns a 401 Forbidden error' do
          allow(@helper).to receive(:params).and_return(token: nil)
          allow(@helper).to receive_message_chain(:request, :headers).and_return('Http-Authorization' => '')
          @helper.token_authentication!
          expect(@helper.message).to eq(message: 'Forbidden', status: 401)
        end
      end
    end
  end
end
