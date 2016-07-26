module Elasticsearch
  module Provider
    module Childs

      class Child
        attr_accessor :index_name, :document_type, :document_mapping,
          :parent_id, :id

        include Elasticsearch::Provider::Client::ClassMethods

        include Elasticsearch::Provider::Document::ClassMethods

        include Elasticsearch::Provider::Request::Search::ClassMethods
        include Elasticsearch::Provider::Request::Delete::ClassMethods
        include Elasticsearch::Provider::Request::Create::ClassMethods
        include Elasticsearch::Provider::Request::Update::ClassMethods

        include Elasticsearch::Provider::Response::Results

        def initialize
          @object_tree = {}
        end

        def all
          search({parent: parent_id}).results._source
        rescue Elasticsearch::Transport::Transport::Errors::NotFound
          []
        end

        def release
          object = Elasticsearch::Provider::Childs::Child.new

          object.document_mapping = document_mapping
          object.document_type = document_type
          object.index_name = index_name
          object.parent_id = parent_id
          object.id = id

          object
        end

        def save
          _document = {}
          @object_tree.each { |key, item|
            _document[key] = item.object_value
          }
          document(_document)

          begin
            search({parent: parent_id})
            update({parent: parent_id})
          rescue Elasticsearch::Transport::Transport::Errors::NotFound
            super({parent: parent_id})
          end
        end

        def delete
          super({parent: parent_id})
        end

        def select(name)
          search({parent: id}).results._source[name]
        rescue Elasticsearch::Transport::Transport::Errors::NotFound
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

            @object_tree[method_name.to_s] = _object

            if operation.nil?
              select(method_name.to_s)
            else
              _object.assignment(*args) if operation == '='
            end
          else
            super
          end
        end
      end
    end
  end
end
