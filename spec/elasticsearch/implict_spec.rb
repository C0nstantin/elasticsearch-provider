require 'spec_helper'

describe Elasticsearch::Provider::Parser do
  class DummyClass
    include Elasticsearch::Provider

    document_type 'doc'

    def implict
      {properties: {id: self.id}}
    end
  end

  let(:request) do
    request = DummyClass.new
  end

  it 'class set id response' do
    expect(request.id('test')).to be_an(DummyClass)
  end

  it 'class propperties for class method' do
    expect(
      request.id('test').implict
    ).to eq({properties: {id: 'test'}})
  end

  it 'class propperties for implict method' do
    expect(
      request.elastic.id('test').implict
    ).to eq({properties: {id: 'test'}})
  end

  it 'undefined method implict exeption' do
    expect {
      request.elastic.id('test').notpresent
    }.to raise_error(NoMethodError)
  end

  it 'undefined method class exeption' do
    expect {
      request.notpresent
    }.to raise_error(NoMethodError)
  end
end
