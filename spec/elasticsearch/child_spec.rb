require 'spec_helper'

describe Elasticsearch::Provider::Childs, :elasticsearch_child do
  class DummyClass
    include Elasticsearch::Provider

    index_name 'test'
    document_type 'doc'

    child_type 'prop'
  end

  let(:request) { DummyClass.new }

  it 'class properties return' do
    expect(
      request.child
    ).to be_an(Elasticsearch::Provider::Childs::Class)
  end

  it 'undefined method in mapping exeption' do
    expect {
      request.child.notpresent
    }.to raise_error(NoMethodError)
  end

  it 'child object properties' do
    expect(
      request.child.present
    ).to be_an(Elasticsearch::Provider::Childs::Boolean)
  end
end
