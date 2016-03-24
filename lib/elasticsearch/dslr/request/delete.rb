module Elasticsearch
  module DSLR
    module Request
      module Delete

        module ClassMethods
          def delete(options={})
            case
              when id.is_a?(String) || id.is_a?(Integer)
                client.delete({
                  index: index_name, type: document_type, id: id
                }.merge(options))
              when id.is_array?
                bulk_delete(id)
              when self.respond_to?(:to_hash)
                result = {'hits' => {'total' => '-1'}}
                request_hash = self.from(0).size(bulk_size).to_hash
                while result['hits']['total'].to_i != 0  do
                  delete_ids = []
                  response = client.search({
                    index: index_name, type: document_type, body: request_hash
                  }.merge(options))
                  response['hits']['hits'].map { |item|
                    delete_ids.push item['_id']
                  }
                  delete_response = bulk_delete(delete_ids)
                end
                delete_response
            end
          end

          def bulk_delete(delete_ids)
            delete_ids.each_slice(bulk_size) do |batch|
              batch.each do |delete_id|
                request.push delete: {
                  _index: index_name,
                  _type: document_type,
                  _id: delete_id
                }

                last_response = client.bulk body: request
              end
            end
          end
        end

        def bulk_size size=500
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
