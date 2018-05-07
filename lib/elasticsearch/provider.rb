require 'elasticsearch'
require 'elasticsearch/dsl'

require 'elasticsearch/provider/version'
require 'elasticsearch/provider/client'
require 'elasticsearch/provider/naming'
require 'elasticsearch/provider/document'
require 'elasticsearch/provider/parser'
require 'elasticsearch/provider/request/search'
require 'elasticsearch/provider/request/delete'
require 'elasticsearch/provider/request/create'
require 'elasticsearch/provider/request/update'
require 'elasticsearch/provider/response/results'
require 'elasticsearch/provider/childs/naming'
require 'elasticsearch/provider/childs/class'
require 'elasticsearch/provider/childs/base'

Dir[
  File.expand_path('../provider/childs/types/*.rb', __FILE__)
].each { |f| require f }

require 'elasticsearch/provider/class'

module Elasticsearch
  module Provider

    module ClassMethods

      def client client=nil
        @client = client || @client || Elasticsearch::Client.new
      end

      def client=(client)
        @client = client
      end

    end

    extend ClassMethods

    # Delegate methods to the repository (acting as a gateway)
    #
    module GatewayDelegation
      def method_missing(method_name, *arguments, &block)
        if gateway.respond_to?(method_name)
          gateway.__send__(:implict, self)
          gateway.__send__(method_name, *arguments, &block)
        else
          super
        end
      end

      def respond_to?(method_name, include_private=false)
        gateway.respond_to?(method_name) || super
      end

      def respond_to_missing?(method_name, *)
        gateway.respond_to?(method_name) || super
      end
    end

    def self.included(base)
      gateway = Elasticsearch::Provider::Model::Class.new

      base.class_eval do
        define_method :gateway do
          @gateway ||= gateway
        end

        include GatewayDelegation
      end

      # Define the class level gateway
      #
      (class << base; self; end).class_eval do
        define_method :gateway do |&block|
          @gateway ||= gateway
          @gateway.instance_eval(&block) if block
          @gateway
        end

        include GatewayDelegation
      end

    end
  end
end
