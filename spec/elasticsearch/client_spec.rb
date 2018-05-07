require 'spec_helper'

describe Elasticsearch::Provider::Model, :elasticsearch do
  include Elasticsearch::Provider

  index_name 'test'
  document_type 'doc'

  let(:client) { Elasticsearch::Provider::Client.client }

  it 'GET elasticsearch cluster health success' do
    request = client.perform_request \
      'GET', '_cluster/health'
    expect(request.status).to eql(200)
  end

  it 'create test index' do
    client.indices.delete index: 'test' if client.indices.exists index: 'test'
    request = client.indices.create index: 'test', type: 'doc'
    expect(request).to include("acknowledged")
  end

  it 'search request success' do
    client.indices.put_mapping index: 'test', type: 'doc', \
      body: {doc: {properties: {title: {type: "keyword"}}}}

    elastic.document(title: 'test').save
    expect(
      elastic.query(:match, title: 'test').search.results
    ).to eq([])
  end

  it 'create document and insert data' do
    expect(
      elastic.document({title: 'eeeeee'}).save
    ).to include({"result" => "created"})
  end

  it 'create document and insert data with id' do
    expect(
      elastic.document({title: 'eeeeee'}).id(1).save
    ).to include({"_id" => "1"})
  end

  it 'search by id success' do
    elastic.document({title: 'eeeeee'}).id(1).save
    expect(
      elastic.id(1).search.results
    ).to include({"found" => true})
  end

  it 'update document by id success' do
    elastic.document({title: 'eeeeee'}).id(1).save
    sleep 0.5
    expect(
      elastic.document({title: 'tttttt'}).id(1).update
    ).to include({"_id" => "1"})
  end

  it 'response contains aggregation' do
    aggregation = {
      terms: {
        field: 'title'
      },
      aggregations: {
        dup_doc: {
          top_hits: {
            _source: 'title',
            size: 1
          }
        }
      }
    }

    expect(
      elastic.aggregation(:title_aggs, aggregation).search.response
    ).to have_key("aggregations")
  end

  #it 'Delete request' do
  #  (1..10).each { |id|
  #    elastic.document(title: "delete_#{id}").save
  #  }
  #  sleep 1
  #  response = elastic.filter(:regexp, title: 'delete_.*').delete
  #  expect(response['items'].size).to eq(10)
  #end
end
