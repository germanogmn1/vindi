require "vindi/version"
require "vindi/uri"
require 'vindi/request'
require 'vindi/api/list'
require 'vindi/api/create'
require 'vindi/api/delete'
require 'vindi/api/update'
require 'vindi/api/get'
require 'vindi/base'
require 'vindi/customer'
require 'vindi/charge'
require 'vindi/payment_profile'
require 'vindi/product'
require 'vindi/payment_method'
require 'vindi/bill'
require 'vindi/response_validator'
require 'vindi/error'
require 'vindi/normalizer'

module Vindi

  module Configuration
    attr_accessor :api_key

    def configure
      yield self
    end
  end

  extend Configuration

  class RateLimit
    attr_reader :limit, :remaining, :reset_at

    def initialize
      @limit = 120 # start with the limit that is on the docs
    end

    def update(response)
      @limit = response.headers['Rate-Limit-Limit'].to_i
      @remaining = response.headers['Rate-Limit-Remaining'].to_i
      @reset_at = Time.at(response.headers['Rate-Limit-Reset'].to_i)
    end

    def available
      reset? ? @limit : @remaining
    end

    def reset?
      @reset_at.nil? || Time.now > @reset_at
    end
  end

  def self.rate_limit
    @rate_limit ||= RateLimit.new
  end
end
