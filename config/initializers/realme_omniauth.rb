# frozen_string_literal: true

OmniAuth::Strategies::Realme.configure do |config|
  # Website issuer namespace
  config.issuer = ENV['REALME_ISSUER']

  # Callback url
  config.assertion_consumer_service_url = ENV['REALME_CALLBACK']

  # Sign the request saml and decrypt response
  config.private_key = ENV['REALME_CERT']

  # Realme login service xml file.
  # You will need to download the different XML files for the different environments found here:
  # https://developers.realme.govt.nz/how-realme-works/technical-integration-steps/
  # config.idp_service_metadata = Rails.root.join('vendor', 'realme', 'ite-logon-service-metadata.xml')
  config.idp_service_metadata = Rails.root.join('vendor', 'realme', 'mts', 'MTSIdPLoginSAMLMetadata.xml')

  # default strength
  config.auth_strenght = 'urn:nzl:govt:ict:stds:authn:deployment:GLS:SAML:2.0:ac:classes:LowStrength'
end
