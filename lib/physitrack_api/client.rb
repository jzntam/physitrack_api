require "httparty"
require 'active_support/core_ext/object'

module PhysitrackApi
  class Client
    def initialize(api_key:, subdomain:)
      raise ArgumentError.new('You must provide a Physitrack API Key')   unless api_key.present?
      raise ArgumentError.new('You must provide a Physitrack subdomain') unless subdomain.present?

      @api_key   = api_key
      @subdomain = subdomain
    end
  end
end
