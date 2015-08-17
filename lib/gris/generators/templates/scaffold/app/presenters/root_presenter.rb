module RootPresenter
  include Gris::RootPresenter

  link :self do
    Gris::Identity.base_url
  end

  # Additional endpoint links
  endpoint_link :health
end
