module Elasticsearch
  module Provider

    module Childs
      module Naming
        module ClassMethods

          def child_mapping object=nil
            @child_mapping = object || @child_mapping
          end

          def child_mapping=(name)
            @child_mapping = name
          end

          def child_type name=nil
            @child_type = name || @child_type || ''
          end

          def child_type=(name)
            @child_type = name
          end

          def child_parent name=nil
            @child_parent = name || @child_parent || @index_name
          end

          def child_parent=(name)
            @child_parent = name
          end

        end

        extend ClassMethods
      end
    end
  end
end
