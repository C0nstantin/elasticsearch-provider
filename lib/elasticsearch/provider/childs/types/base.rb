module Elasticsearch
  module Provider
    module Childs

      class Base
        attr_accessor :object_name, :object_mapping, :object_value

        def assignment(args)
          self.object_value = args
        end
      end

    end
  end
end
