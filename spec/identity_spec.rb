require 'spec_helper'

describe Gris::Identity do
  include_context 'with secrets from config/secrets.yml'

  before do
    allow(Process).to receive(:pid).and_return(123)
    allow(Gris::Identity).to receive(:hostname).and_return('system-hostname')
    allow(Gris::Identity).to receive(:`).with('git rev-parse HEAD').and_return('12345')
  end

  context '#health' do
    it 'includes name' do
      expect(Gris::Identity.health[:name]).to eq Gris::Identity.name
    end

    it 'includes base_url' do
      expect(Gris::Identity.health[:base_url]).to eq Gris::Identity.base_url
    end

    it 'includes hostname' do
      expect(Gris::Identity.health[:hostname]).to eq Gris::Identity.hostname
    end

    it 'includes database_version' do
      expect(Gris::Identity.health[:database_version]).to eq 'awww-yeah'
    end

    it 'includes revision' do
      expect(Gris::Identity.health[:revision]).to eq Gris::Identity.revision
    end

    it 'includes pid' do
      expect(Gris::Identity.health[:pid]).to eq Gris::Identity.pid
    end

    it 'includes parent_pid' do
      expect(Gris::Identity.health[:parent_pid]).to eq Gris::Identity.parent_pid
    end

    it 'includes platform' do
      expect(Gris::Identity.health[:platform]).to eq Gris::Identity.platform
    end
  end

  context '#name' do
    it 'returns the Gris.secrets.service_name when specified' do
      expect(Gris::Identity.name).to eq 'my_test_app'
    end
  end

  context '#hostname' do
    it 'returns the value of the hostname system call and doesn\'t make a second system call' do
      expect(Gris::Identity).to_not receive(:`).with('hostname')
      expect(Gris::Identity.hostname).to eq 'system-hostname'
    end
  end

  context '#revision' do
    it 'returns the value of the \'git rev-parse HEAD\' system call and doesn\'t make a second system call' do
      expect(Gris::Identity).to_not receive(:`).with('git rev-parse HEAD')
      expect(Gris::Identity.revision).to eq '12345'
    end
  end

  context '#pid' do
    it 'returns the process ID value' do
      expect(Gris::Identity.pid).to eq 123
    end
  end

  context '#platform_revision' do
    it 'returns the current version of the platform gem' do
      expect(Gris::Identity.platform_revision).to eq Gris::VERSION
    end
  end

  context '#base_url' do
    it 'returns the Gris.secrets.base_url when specified' do
      expect(Gris::Identity.base_url).to eq 'https://www.youtube.com/watch?v=RI6973HNh8Y'
    end
  end
end
