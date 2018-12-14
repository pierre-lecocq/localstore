# File: localstore_spec.rb
# Time-stamp: <2018-12-14 08:08:11>
# Copyright (C) 2018 Pierre Lecocq
# Description: LocalStore module spec

require_relative '../lib/localstore'

describe LocalStore do
  before :all do
    class TestLocalStore
      extend LocalStore

      localstore :test
    end
  end

  it 'checks class methods' do
    expect(TestLocalStore).to respond_to :test_store
    expect(TestLocalStore).to respond_to :test_fetch
    expect(TestLocalStore).to respond_to :test_flush
  end

  it 'checks instance methods' do
    obj = TestLocalStore.new

    expect(obj).to respond_to :test_store
    expect(obj).to respond_to :test_fetch
    expect(obj).to respond_to :test_flush
  end

  it 'checks local store from class methods calls' do
    TestLocalStore.test_store :key_1, '1'
    TestLocalStore.test_store :key_2, '2'

    expect(TestLocalStore.test_fetch(:key_1)).to be == '1'
    expect(TestLocalStore.test_fetch(:key_2)).to be == '2'
    expect(TestLocalStore.test_fetch).to be == { key_1: '1', key_2: '2' }

    TestLocalStore.test_flush

    expect(TestLocalStore.test_fetch).to be == {}
  end

  it 'checks local store from instance methods calls' do
    obj = TestLocalStore.new

    obj.test_store :key_3, '3'
    obj.test_store :key_4, '4'

    expect(obj.test_fetch(:key_3)).to be == '3'
    expect(obj.test_fetch(:key_4)).to be == '4'
    expect(obj.test_fetch).to be == { key_3: '3', key_4: '4' }

    obj.test_flush

    expect(obj.test_fetch).to be == {}
  end
end
