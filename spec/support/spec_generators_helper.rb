shared_context 'with generator' do
  let(:generator_tmp_directory) { 'spec/tmp' }

  before do
    allow_any_instance_of(described_class).to receive(:output_directory).and_return(generator_tmp_directory)
  end

  after do
    FileUtils.rm_rf(generator_tmp_directory)
  end
end
