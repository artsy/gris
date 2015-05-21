shared_context 'with a generated app' do
  let(:app_name) { 'my_test_app' }
  let(:options) { {} }
  let(:app_port) { 9292 }
  let(:args) { [app_name] }

  before(:each) do
    scaffold = Gris::CLI::Base.new(args, options)
    scaffold.invoke(:new)
    prepare_app
  end

  after(:each) do
    @app.stop
    cleanup_generated_app
  end

  def prepare_app
    Bundler.with_clean_env do
      project = ChildProcess.build('bundle', 'install')
      project.io.inherit!
      project.cwd = app_name
      project.start
      project.wait
      begin
        project.poll_for_exit(10)
        start_app
      rescue ChildProcess::TimeoutError
        project.stop
      end
    end
  end

  def start_app
    @app = ChildProcess.build('bundle', 'exec', 'rackup')
    @app.environment['PERMITTED_TOKENS'] = 'replace-me'
    @app.io.inherit!
    @app.cwd = app_name
    @app.start
    sleep(1) while !listening_on?(app_port) && @app.alive?
  end

  def listening_on?(port)
    system("netstat -an | grep #{port} | grep LISTEN")
  end

  def cleanup_generated_app
    FileUtils.rm_rf(args[0])
  end
end
