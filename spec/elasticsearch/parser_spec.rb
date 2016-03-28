require 'spec_helper'

describe Elasticsearch::DSLR::Parser do
  class DummyClass
    include Elasticsearch::DSLR
  end

  let(:request) do
    request = DummyClass.new.request
  end

  it 'Has a version number' do
    expect(Elasticsearch::DSLR::VERSION).to match(/\d+\.\d+\.\d+/)
  end

  it 'Match query response check' do
    expect(
      request.query(:match, title: 'test').to_hash
    ).to eq(
      :query=>{:match=>{:title=>"test"}}
    )
  end

  it 'Multi_match query response check' do
    expect(
      request.query(
        :multi_match, query: 'test', fields: [:title, :abstract, :content]
      ).to_hash
    ).to eq(
      :query => {:multi_match=>{:query=>"test",
                                :fields=>[:title, :abstract, :content]}}
    )
  end

  it 'Filter query response check' do
    expect(
      request.filter(:regexp, category: 'test').to_hash
    ).to eq(:query => {:filtered=>{:filter=>{:regexp=>{:category=>"test"}}}})
  end

  it 'Check query filter response' do
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

  it 'Check function_score filter response' do
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

  it 'Check highlight request' do
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

  it 'Check query filter aggregation' do
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
