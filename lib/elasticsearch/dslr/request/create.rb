module Elasticsearch
  module DSLR
    module Request
      module Create

        module ClassMethods
          def save(options={})
            if document.respond_to?(:to_hash)
              response = client.indices.create({
                index: index_name, type: document_type, body: document
              }.merge(options))
            else
              raise ArgumentError,
                "[!] Pass the save definition object as a Hash-like object" +
                " -- #{self.class} given."
            end
            response
          end
        end

        extend ClassMethods
      end
    end
  end
end
