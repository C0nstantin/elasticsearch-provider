module Elasticsearch
  module Provider
    module Request
      module Delete

        module ClassMethods
          def delete(options={})
            response = {"errors" => false, "items" => []}
            result = {'hits' => {'total' => '-1'}}

            case
            when id.is_a?(String) || id.is_a?(Integer)
              response = client.delete({
                index: index_name, type: document_type, id: id
              }.merge(options))
            when !id.nil? && id.is_array?
              response = bulk_delete(id)
            when self.respond_to?(:to_hash)
              while result['hits']['total'].to_i != 0 do
                delete_ids = []

                _partition = self.size(bulk_size).to_hash
                result = client.search({
                  index: index_name, type: document_type, body: _partition
                }).merge(options)

                if result['hits']['total'].to_i > 0
                  result['hits']['hits'].map { |item|
                    delete_ids.push item['_id']
                  }

                  response = bulk_delete(delete_ids)
                end

                break if result['hits']['total'].to_i < bulk_size
                sleep 1
              end
            end

            response
          end

          def bulk_delete(_ids)
            _bulk = []
            _ids.each do |_id|
              _bulk.push delete: {
                _index: index_name,
                _type: document_type,
                _id: _id
              }
            end
            if _bulk.size > 0
              client.bulk body: _bulk
            else
              {"errors" => false, "items" => []}
            end
          end

          def bulk_size size = 1000
            @bulk_size || size
          end

          def bulk_size=(size)
            @bulk_size = size
            @bulk_size
          end

          extend ClassMethods
        end
      end
    end
  end
end
