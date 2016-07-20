require 'spec_helper'

describe Elasticsearch::Provider::Parser do
  class DummyClass
    include Elasticsearch::Provider
  end

  let(:request) do
    request = DummyClass.elasticsearch
  end

  it 'has a version number' do
    expect(Elasticsearch::Provider::VERSION).to match(/\d+\.\d+\.\d+/)
  end

  it 'match query response' do
    expect(
      request.query(:match, title: 'test').to_hash
    ).to eq(
      :query=>{:match=>{:title=>"test"}}
    )
  end

  it 'multi_match query response' do
    expect(
      request.query(
        :multi_match, query: 'test', fields: [:title, :abstract, :content]
      ).to_hash
    ).to eq(
      :query => {:multi_match=>{:query=>"test",
                                :fields=>[:title, :abstract, :content]}}
    )
  end

  it 'filter query response' do
    expect(
      request.filter(:regexp, category: 'test').to_hash
    ).to eq(:query => {:filtered=>{:filter=>{:regexp=>{:category=>"test"}}}})
  end

  it 'query filter response' do
    expect(
      request.
        query(:match, title: 'test').
        filter(:regexp, category: 'test').
        to_hash
    ).to eq(
      :query=>{
        :filtered=>{
          :query=>{:match=>{:title=>"test"}},
          :filter=>{:regexp=>{:category=>"test"}}
        }
      }
    )
  end

  it 'query bool filter response' do
    expect(
      request.
        query(:match, title: 'test').
        filter(:bool, {
          should: {
            regexp: {category: "test"}
          },
          must_not: {
            term: {price: 30}
          }
        }).
        to_hash
    ).to eq(
      :query=>{
        :filtered=>{
          :query=>{:match=>{:title=>"test"}},
          :filter=>{
            :bool=>{
              :should=>{:regexp=>{:category=>"test"}},
              :must_not=>{:term=>{:price=>30}}
            }
          }
        }
      }
    )
  end

  it 'function_score filter response' do
    expect(
      request.
        function_score(
          :script_score, script: 'test script', boost_mode: 'replace'
        ).to_hash
    ).to eq({
      :query => {
        :function_score=>{
          :script_score=>{:script=>"test script"},
          :boost_mode=>"replace"
        }
      }
    })
  end

  it 'highlight request' do
    highlight = {
      pre_tags: ["<b>"],
      post_tags: ["</b>"],
      fields: {
        meta_keywords: {},
        meta_description: {}
      }
    }

    expect(
      request.highlight(highlight).to_hash
    ).to eq(
      :highlight => {
        :pre_tags=>["<b>"],
        :post_tags=>["</b>"],
        :fields=>{
          :meta_keywords=>{},
          :meta_description=>{}
        }
      })
  end

  it 'query filter aggregation' do
    aggregation = {
      terms: {
        field: "category"
      }
    }

    filter_request = request.
      query(:match, title: 'test').
      filter(:regexp, category: 'test.*')

    expect(
      filter_request.aggregation(:category_aggs, aggregation).to_hash
    ).to include(
      :aggregations => {:category_aggs=>{:terms=>{:field=>"category"}}}
    )
  end
end
