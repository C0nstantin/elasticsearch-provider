module Elasticsearch
  module DSLR

    # Provides methods for getting and setting index name and document type for the model
    #
    module Naming
      module ClassMethods
        def index_name name=nil, &block
          if name || block_given?
            return (@index_name = name || block)
          end

          if @index_name.respond_to?(:call)
            @index_name.call
          else
            @index_name || ''
          end
        end

        def index_name=(name)
          @index_name = name
        end

        def document_type name=nil
          @document_type = name || @document_type || ''
        end

        def document_type=(name)
          @document_type = name
        end
      end

      extend ClassMethods
    end
  end
end
