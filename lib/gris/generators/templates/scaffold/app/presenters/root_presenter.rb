module RootPresenter
  include Gris::Presenter

  link :self do |opts|
    "#{base_url(opts)}"
  end

  link :health do |opts|
    { href: "#{base_url(opts)}/health" }
  end

  private

  def base_url(opts)
    request = Grape::Request.new(opts[:env])
    request.base_url
  end
end
