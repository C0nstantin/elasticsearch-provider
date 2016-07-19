module Elasticsearch
  module DSLR
    module Model

      class Class < Elasticsearch::DSL::Search::Search

        include Elasticsearch::DSLR::Client::ClassMethods
        include Elasticsearch::DSLR::Naming::ClassMethods
        include Elasticsearch::DSLR::Document::ClassMethods

        include Elasticsearch::DSLR::Parser::ClassMethods

        include Elasticsearch::DSLR::Request::Search::ClassMethods
        include Elasticsearch::DSLR::Request::Delete::ClassMethods
        include Elasticsearch::DSLR::Request::Create::ClassMethods
        include Elasticsearch::DSLR::Request::Update::ClassMethods
        include Elasticsearch::DSLR::Response::Results

        def elasticsearch(*args, &block)
          instance_var = [
            '@query', '@hash', '@block', '@value', '@highlight', '@args'
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
