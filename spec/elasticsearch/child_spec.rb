require 'spec_helper'

describe Elasticsearch::Provider::Childs, :elasticsearch_child do
  class DummyClass
    include Elasticsearch::Provider

    index_name 'test'
    document_type 'doc'

    child_type 'prop'
  end

  let(:childs) { DummyClass.new.id('first').childs }

  it 'parent id not set' do
    expect {
      DummyClass.new.childs
    }.to raise_error(TypeError)
  end

  it 'class properties return' do
    expect(
      childs
    ).to be_an(Elasticsearch::Provider::Childs::Child)
  end

  it 'undefined method in mapping exeption' do
    expect {
      childs.notpresent
    }.to raise_error(NoMethodError)
  end

  it 'child object properties' do
    expect(
     childs.present
    ).to be_an(Elasticsearch::Provider::Childs::Boolean)
  end

  it 'get all childs by parent' do
    expect(
      childs.all
    ).to eq([])
  end

  it 'operation create' do
    expect(
     childs.create
    ).to be_an(Elasticsearch::Provider::Childs::Child)
  end

  it 'save child' do
    childs.present = true
    childs.save
  end
end
