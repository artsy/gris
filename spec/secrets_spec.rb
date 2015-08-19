require 'spec_helper'

describe 'Gris.secrets' do
  context 'with a local yaml file' do
    include_context 'with secrets from config/secrets.yml'

    it 'sets the secret property corresponding to the current Gris.env' do
      expect(Gris.secrets.service_name).to eq 'my_test_app'
    end

    it 'sets the secret property corresponding to the default value' do
      expect(Gris.secrets.base_url).to eq 'https://www.youtube.com/watch?v=RI6973HNh8Y'
    end
  end

  context 'without a local yaml file' do
    [true, 1, 0, 'anystring'].each do |value|
      it "returns true when value is #{value.inspect}" do
        Gris.secrets.notifications_enabled = value
        expect(Gris.secrets.notifications_enabled?).to be_truthy
      end
    end

    [false, nil].each do |value|
      it "returns false when value is #{value.inspect}" do
        Gris.secrets.notifications_enabled = value
        expect(Gris.secrets.notifications_enabled?).to_not be_truthy
      end
    end
  end
end
