require 'elasticsearch'
require 'elasticsearch/dsl'
require 'hashie'

require 'elasticsearch/dslr/version'
require 'elasticsearch/dslr/client'
require 'elasticsearch/dslr/naming'
require 'elasticsearch/dslr/document'
require 'elasticsearch/dslr/parser'
require 'elasticsearch/dslr/request/search'
require 'elasticsearch/dslr/request/delete'
require 'elasticsearch/dslr/request/create'
require 'elasticsearch/dslr/request/update'
require 'elasticsearch/dslr/response/results'
require 'elasticsearch/dslr/class'

module Elasticsearch
  module DSLR

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
      gateway = Elasticsearch::DSLR::Model::Class.new

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
