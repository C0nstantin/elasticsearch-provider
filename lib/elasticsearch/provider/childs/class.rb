module Elasticsearch
  module Provider
    module Childs

      class Child
        attr_accessor :index_name, :document_type, :document_mapping,
          :parent_id

        include Elasticsearch::Provider::Client::ClassMethods

        include Elasticsearch::Provider::Document::ClassMethods

        include Elasticsearch::Provider::Request::Search::ClassMethods
        include Elasticsearch::Provider::Request::Delete::ClassMethods
        include Elasticsearch::Provider::Request::Create::ClassMethods
        include Elasticsearch::Provider::Request::Update::ClassMethods

        include Elasticsearch::Provider::Response::Results

        def initialize
          @object_tree = []
        end

        def all
          id(parent_id).search({parent: parent_id}).results._source
        rescue Elasticsearch::Transport::Transport::Errors::NotFound
          []
        end

        def reload
          object = Elasticsearch::Provider::Childs::Child.new

          object.document_mapping = document_mapping
          object.document_type = document_type
          object.index_name = index_name
          object.parent_id = parent_id

          object
        end

        def save
          self.id = parent_id

          _document = {}
          @object_tree.each { |item|
            _document[item.object_name] = item.object_value
          }
          document(_document)

          begin
            search({parent: parent_id})
            update({parent: parent_id})
          rescue Elasticsearch::Transport::Transport::Errors::NotFound
            super({parent: parent_id})
          end
        end

        def method_missing(method_name, *args, &block)
          _mapping =
            document_mapping[index_name]['mappings'][document_type]['properties']

          if method_name[-1..-1] == '='
            operation = '='
            method_name = method_name[0..-2]
          end

          if _mapping.has_key?(method_name.to_s)
            _current = _mapping[method_name.to_s]

            _object = Object.const_get(
              "Elasticsearch::Provider::Childs::#{_current['type'].capitalize}"
            ).new

            _object.object_name = method_name
            _object.object_mapping = {method_name => _current}

            _object.assignment(*args) if operation == '='

            @object_tree.push(_object)

            _object
          else
            super
          end
        end
      end
    end
  end
end
