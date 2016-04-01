module Elasticsearch
  module DSLR
    module Parser

      module Utils
        def self.first_from_hash(parse)
          body = {}; args = {}
          parse.each do |key, value|
            if body.empty?
              body[key] = value
            else
              args[key] = value
            end
          end
          return body, args
        end
      end

      module ClassMethods
        include Elasticsearch::DSL::Search

        def query(request_type, *args)
          request = Proc.new {send(request_type, *args)}
          @query = Query.new :query, &request
          self
        end

        def filter(filter_type, *args)
          _query = @query.to_hash if @query
          @query = Queries::Filtered.new do
            query _query if _query
            filter do
              send(filter_type, *args)
            end
          end
          self
        end

        def function_score(function_type, args={})
          _query = @query.to_hash if @query
          _body, _args = Utils.first_from_hash(args)
          @query = Queries::FunctionScore.new do
            query _query if _query
            send(function_type, _body)
            boost _args[:boost] if _args[:boost]
            max_boost _args[:max_boost] if _args[:max_boost]
            score_mode _args[:score_mode] if _args[:score_mode]
            boost_mode _args[:boost_mode] if _args[:boost_mode]
          end
          self
        end
      end

    end
  end
end
