$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "rake"
require 'elasticsearch/extensions/test/cluster/tasks'
require 'elasticsearch/provider'

RSpec.configure do |config|
  config.before :each, :elasticsearch do
    unless Elasticsearch::Extensions::Test::Cluster.running?
      Elasticsearch::Extensions::Test::Cluster.start \
        port: 9250,
        nodes: 1
      Elasticsearch::Provider.client = Elasticsearch::Client.new \
        url: 'localhost:9250',
        log: 'true'
    end
  end

  config.before :each, :elasticsearch_child do
    unless Elasticsearch::Extensions::Test::Cluster.running?
      Elasticsearch::Extensions::Test::Cluster.start \
        port: 9250,
        nodes: 1
      Elasticsearch::Provider.client = Elasticsearch::Client.new \
        url: 'localhost:9250',
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
            type: "string"
          },
          present: {
            type: "boolean"
          },
          ranked: {
            type: "nested",
            properties: {
              content: {
                type: "string",
                index: "not_analyzed"
              },
              rank: {
                type: "float"
              }
            }
          }
        }
      }
    },
    ignore_conflicts: true

    client.indices.put_mapping index: 'test', type: 'doc', body: {
      doc: {
        properties: {
          id: {
            type: "string"
          }
        }
      }
    },
    ignore_conflicts: true
  end

  config.after :suite do
   if Elasticsearch::Extensions::Test::Cluster.running?
     Elasticsearch::Extensions::Test::Cluster.stop(port: 9250)
   end
  end
end
