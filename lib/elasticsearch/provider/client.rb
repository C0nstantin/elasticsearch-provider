module Elasticsearch
  module Provider
    module Client

      module ClassMethods
        def client client=nil
          @client = client || @client || Elasticsearch::Provider.client
        end

        def client=(client)
          @client = client
          @client
        end
      end

      extend ClassMethods
    end
  end
end
