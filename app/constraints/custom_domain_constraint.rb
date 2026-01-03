class CustomDomainConstraint
  def initialize(primary_hosts: nil)
    @primary_hosts = Array(primary_hosts).presence || default_primary_hosts
  end

  def matches?(request)
    !@primary_hosts.include?(request.host)
  end

  private

  def default_primary_hosts
    if Rails.env.production?
      [ "twine.no", "www.twine.no" ]
    else
      [ "localhost", "127.0.0.1", "::1", "www.example.com", "example.com" ]
    end
  end
end
