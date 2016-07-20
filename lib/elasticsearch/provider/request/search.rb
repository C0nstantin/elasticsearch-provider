module Elasticsearch
  module Provider
    module Request
      module Search

        module ClassMethods
          def search(options={})
            if id.is_a?(String) || id.is_a?(Integer)
              response = client.get({
                index: index_name, type: document_type, id: id
              }.merge(options))
            elsif self.respond_to?(:to_hash)
              response = client.search({
                index: index_name, type: document_type, body: self.to_hash
              }.merge(options))
            else
              raise ArgumentError,
                "[!] Pass the search definition as a Hash-like object" +
                " -- #{self.class} given."
            end

            Response::Results::Class.new(self, response)
          end

          def count(options={})
            response = search options.update(search_type: 'count')
            response.response.hits.total
          end
        end

        extend ClassMethods
      end
    end
  end
end
