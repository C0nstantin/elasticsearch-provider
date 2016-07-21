module Elasticsearch
  module Provider
    module Childs

      class Class
        attr_accessor :index_name, :document_type, :document_mapping

        def method_missing(method_name, *args, &block)
          _mapping =
            document_mapping[index_name]['mappings'][document_type]['properties']

          if _mapping.has_key?(method_name.to_s)
            #puts "=========#{_mapping}=============#{@mapping_mash}=="

            _current = _mapping[method_name.to_s]

            Object.const_get(
              "Elasticsearch::Provider::Childs::#{_current['type'].capitalize}"
            ).new(index_name, document_type, _current)

            #_mapping[method_name]
          else
            super
          end
        end
      end
    end
  end
end
