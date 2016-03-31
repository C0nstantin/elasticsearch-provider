module Elasticsearch
  module DSLR
    module Request
      module Create

        module ClassMethods
          def save(options={})
            if document.respond_to?(:to_hash)
              client.create({
                index: index_name, type: document_type, id: id, body: document
              }.merge(options))
            else
              raise ArgumentError,
                "[!] Pass the save definition object as a Hash-like object" +
                " -- #{self.class} given."
            end
          end
        end

        extend ClassMethods
      end
    end
  end
end
