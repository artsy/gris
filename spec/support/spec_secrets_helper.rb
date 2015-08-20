shared_context 'with secrets from config/secrets.yml' do
  include FakeFS::SpecHelpers

  before do
    content = IO.read 'spec/fixtures/secrets.yml'
    FileUtils.mkdir_p 'config'
    File.open('config/secrets.yml', 'w+') do |file|
      file.write content
    end
  end
end
