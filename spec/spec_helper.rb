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

  config.after :suite do
   if Elasticsearch::Extensions::Test::Cluster.running?
     Elasticsearch::Extensions::Test::Cluster.stop(port: 9250)
   end
  end
end
