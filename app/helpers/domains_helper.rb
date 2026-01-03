module DomainsHelper
  def on_custom_domain?
    CustomDomainConstraint.new.matches?(request)
  end
end
