module Elasticsearch
  module Provider
    module Childs

      class Base
        attr_accessor :index_name, :document_type, :mapping, :current_object

        def initialize(index, type, structure)
          index_name = index
          document_type = type
          mapping = structure
        end
      end

    end
  end
end
