require 'spec_helper'

describe Elasticsearch::DSLR::Model, :elasticsearch do
  class DummyClass
    include Elasticsearch::DSLR

    index_name 'test'
    document_type 'doc'
  end

  let(:request) do
    request = DummyClass.elasticsearch
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

  it 'Create document and insert data with id' do
    response = request.document({title: 'eeeeee'}).id(1).save
    expect(response).to include({"created" => true}, {"_id" => "1"})
  end

  it 'Response contains aggregation' do
    aggregation = {terms: {field: "title"}}

    aggs_request = request.
      query(:match, title: 'eeee').
      aggregation(:category_aggs, aggregation).search

    expect(aggs_request.response).to have_key("aggregations")
  end
end
