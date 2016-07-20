module Elasticsearch
  module Provider
    module Request
      module Update

        module ClassMethods
          def update(options={})
            if id.is_a?(String) || id.is_a?(Integer)
              if document.respond_to?(:to_hash)
                response = client.update({
                  index: index_name, type: document_type, id: id,
                  body: { doc: document.to_hash }
                }.merge(options))
              elsif script.respond_to?(:to_hash)
                response = client.update({
                  index: index_name, type: document_type, id: id,
                  body: script.to_hash
                }.merge(options))
              else
                raise ArgumentError,
                  "[!] Pass the document or script missing" +
                  " -- #{self.class} given."
              end
            else
              raise ArgumentError,
                "[!] Pass the update id" +
                " -- #{self.class} given."
            end

            #Response::Results::Class.new(self, response)
          end
        end

        extend ClassMethods
      end
    end
  end
end
