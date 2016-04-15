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
            if response['hits']
              response['hits']['total'].to_i
            elsif response['found'].present?
              return 1
            else
              return 0
            end
          end

          # The maximum score for a query
          #
          def max_score
            if response['hits']
              response['hits']['max_score']
            end
          end

          def results
            if response['hits']
              @results ||= response['hits']['hits'].map do |document|
                Hashie::Mash.new(document)
              end
            else
              response
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
