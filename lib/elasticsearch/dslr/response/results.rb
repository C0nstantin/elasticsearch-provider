module Elasticsearch
  module DSLR
    module Response
      module Results

        class Class
          include Enumerable

          def initialize(repository, response)
            @response = Hashie::Mash.new(response)
            @repository = repository
          end

          # The number of total hits for a query
          #
          def total
            response['hits']['total']
          end

          # The maximum score for a query
          #
          def max_score
            response['hits']['max_score']
          end

          def results
            @results ||= response['hits']['hits'].map do |document|
              Hashie::Mash.new(document)
            end
          end

          def response
            @response
          end
        end
      end
    end
  end
end
