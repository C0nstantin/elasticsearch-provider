$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "rake"
require 'elasticsearch/extensions/test/cluster/tasks'
require 'elasticsearch/provider'

RSpec.configure do |config|
  config.before :each, :elasticsearch do
    unless Elasticsearch::Provider.client
      Elasticsearch::Provider.client = Elasticsearch::Client.new \
        url: 'elasticsearch.dev.local:9250',
        log: 'true'
    end
  end

  config.before :each, :elasticsearch_child do
    unless Elasticsearch::Provider.client
      Elasticsearch::Provider.client = Elasticsearch::Client.new \
        url: 'elasticsearch.dev.local:9250',
        log: 'true'
    end

    client = Elasticsearch::Provider.client
    client.indices.delete index: 'test' if client.indices.exists index: 'test'
    client.indices.create index: 'test', body: {}

    client.indices.put_mapping index: 'test', type: 'prop', body: {
      prop: {
        _parent: {
          type: "doc"
        },
        properties: {
          id: {
            type: "keyword"
          },
          present: {
            type: "boolean"
          },
          ranked: {
            type: "nested",
            properties: {
              content: {
                type: "keyword",
                index: "not_analyzed"
              },
              rank: {
                type: "float"
              }
            }
          }
        }
      }
    }

    client.indices.put_mapping index: 'test', type: 'doc', body: {
      doc: {
        properties: {
          id: {
            type: "keyword"
          }
        }
      }
    }
  end
end
