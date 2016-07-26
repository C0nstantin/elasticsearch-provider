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
    expect { DummyClass.new.childs }.to raise_error(TypeError)
  end

  it 'class properties return' do
    expect(childs).to be_an(Elasticsearch::Provider::Childs::Child)
  end

  it 'undefined method in mapping exeption' do
    expect { childs.notpresent }.to raise_error(NoMethodError)
  end

  it 'child object properties' do
    expect(childs.present).to eq(nil)
  end

  it 'get all childs by parent' do
    expect(childs.all).to eq([])
  end

  it 'save boolean child' do
    childs.present = true
    childs.save

    expect(childs.present).to eq(true)
  end

  describe 'nested object' do
    it 'save child' do
      rank = [
        {content: 'word', rank: 20}, {content: 'test', rank: 22.2}
      ]
      childs.ranked = rank
      childs.save

      expect(childs.ranked).to eq([
        {"content"=>"word", "rank"=>20}, {"content"=>"test", "rank"=>22.2}
      ])
    end

    it 'update child' do
      rank = [
        {content: 'word', rank: 20}, {content: 'test', rank: 22.2}
      ]
      childs.ranked = rank
      childs.save

      expect(childs.ranked).to eq([
        {"content"=>"word", "rank"=>20}, {"content"=>"test", "rank"=>22.2}
      ])

      childs.ranked = [{content: 'word', rank: 25}]
      childs.save

      expect(childs.ranked).to eq([{"content"=>"word", "rank"=>25}])
    end
  end

  it 'delete catch exeption' do
    expect(childs.delete).to eq(nil)
  end

  it 'delete child' do
    childs.present = true
    childs.save

    expect(childs.present).to eq(true)

    childs.delete

    expect(childs.present).to eq(nil)
  end

  it 'reuse child' do
    dummy = DummyClass.new.id('first')
    dummy.childs.present = true
    dummy.childs.save

    expect(dummy.childs.present).to eq(true)
  end

  it 'release object' do
    current = childs
    release = childs.release

    expect(release).to be_an(Elasticsearch::Provider::Childs::Child)

    expect(current).not_to eq(release)
  end
end
