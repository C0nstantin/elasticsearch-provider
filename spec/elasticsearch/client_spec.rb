require 'spec_helper'

describe Elasticsearch::DSLR::Model, :elasticsearch do
  class DummyClass
    include Elasticsearch::DSLR

    index_name 'test'
    document_type 'doc'
  end

  let(:request) do
    request = DummyClass.new.request
  end

  let(:client) { Elasticsearch::DSLR::Client.client }

  it 'GET elasticsearch cluster health success' do
    request = client.perform_request \
      'GET', '_cluster/health'
    expect(request.status).to eql(200)
  end

  it 'Create test index' do
    request = client.indices.create index: 'test'
    expect(request).to eql({"acknowledged"=>true})
  end

  it 'Search request success' do
    client.indices.put_mapping index: 'test', type: 'doc', \
      body: {doc: {properties: {title: {type: "string"}}}}

    expect(request.query(:match, title: 'test').search.results).to eq([])
  end
end
