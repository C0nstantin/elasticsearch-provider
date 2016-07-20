module Elasticsearch
  module Provider
    module Model

      class Class < Elasticsearch::DSL::Search::Search

        include Elasticsearch::Provider::Client::ClassMethods
        include Elasticsearch::Provider::Naming::ClassMethods
        include Elasticsearch::Provider::Document::ClassMethods

        include Elasticsearch::Provider::Parser::ClassMethods

        include Elasticsearch::Provider::Request::Search::ClassMethods
        include Elasticsearch::Provider::Request::Delete::ClassMethods
        include Elasticsearch::Provider::Request::Create::ClassMethods
        include Elasticsearch::Provider::Request::Update::ClassMethods
        include Elasticsearch::Provider::Response::Results

        def elasticsearch(*args, &block)
          instance_var = [
            '@query', '@hash', '@block', '@value', '@highlight', '@args', '@id'
          ]
          instance_var.each { |name|
            if instance_variable_defined?(:"#{name}")
              remove_instance_variable(:"#{name}")
            end
          }
          @options = Elasticsearch::DSL::Search::Options.new if @options

          self
        end
        alias_method :elastic, :elasticsearch

        def implict name=nil
          if name.nil?
            @implict
          else
            @implict = name
          end
        end

        def implict=(name)
          @implict = name
          @implict
        end

        def method_missing(method_name, *args, &block)
          if @implict.respond_to?(method_name)
            @implict.__send__ method_name, *args, &block
          else
            super
          end
        end
      end
    end
  end
end
