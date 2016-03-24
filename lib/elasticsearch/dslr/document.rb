module Elasticsearch
  module DSLR
    module Document

      module ClassMethods
        def document document=nil
          if document.nil?
            @document
          else
            @document = document
            self
          end
        end

        def document=(document)
          @document = document
          @document
        end

        def id id=nil
          if document.nil?
            @id
          else
            @id = id
            self
          end
        end

        def id=(id)
          @id = id
          @id
        end
      end

      extend ClassMethods
    end
  end
end
