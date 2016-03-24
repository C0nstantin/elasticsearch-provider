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
        include Elasticsearch::DSLR::Response::Results

        def request(*args, &block)
          instance = self.class.new
          instance.index_name = self.index_name
          instance.document_type = self.document_type
          instance
        end
      end

    end
  end
end
