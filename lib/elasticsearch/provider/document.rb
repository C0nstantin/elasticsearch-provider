module Elasticsearch
  module Provider
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

        def scipt scipt=nil
          if scipt.nil?
            @script
          else
            @scipt = scipt
            self
          end
        end

        def scipt=(scipt)
          @scipt = scipt
          @script
        end

        def id id=nil
          if id.nil?
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
