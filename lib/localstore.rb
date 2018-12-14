# File: localstore.rb
# Time-stamp: <2018-12-14 08:16:38>
# Copyright (C) 2018 Pierre Lecocq
# Description: LocalStore module for classes

# Provides a class level local data store with namespaces support.
#
# API:
#
# When calling `localstore` at the top of a class definition, class and instance methods are created automatically:
#
# - <namespace>_store(key, value) to store data in the local store
# - <namespace>_fetch(key = nil) to fetch data from the local store
# - <namespace>_flush to flush data from the local store
#
# @example Local storage from class and instance methods
#
#     require 'localstore'
#
#     class TestLocalStore
#       extend LocalStore
#
#       # Initialize namespace
#       localstore :test
#     end
#
#     # Class methods#
#     TestLocalStore.test_store :hello, 'world'
#     p TestLocalStore.test_fetch :hello
#     p TestLocalStore.test_fetch
#     TestLocalStore.test_flush
#     p TestLocalStore.test_fetch
#
#
#     # Instance methods
#     obj = TestLocalStore.new
#     obj.test_store :hello2, 'world2'
#     p obj.test_fetch :hello2
#     p obj.test_fetch
#     obj.test_flush
#     p obj.test_fetch
#
module LocalStore
  # Library name
  NAME = 'localstore'.freeze

  # Semantic version number
  VERSION = [0, 5, 0].join '.'

  # @!visibility private
  attr_reader :_local_store

  # Create a new namespace in the local store and create dynamic class methods
  # to interact with the store
  #
  # @param namespace [Symbol, String] namespace to create
  def localstore(namespace)
    localstores namespace
  end

  # Create multiple new namespaces in the local store and create dynamic class
  # methods to interact with the store
  #
  # @param namespaces [Array<Symbol>, Array<String>] namespaces to create
  def localstores(*namespaces)
    namespaces.each do |namespace|
      @_local_store ||= {}
      @_local_store[namespace] ||= {}

      create_class_methods namespace
      create_instance_methods namespace
    end
  end

  # Create class metods according to the namespace
  #
  # @api private
  #
  # @param namespace [Symbol, String]
  def create_class_methods(namespace)
    self.class.send :define_method, "#{namespace}_store" do |key, value|
      @_local_store[namespace][key] = value
    end

    self.class.send :define_method, "#{namespace}_fetch" do |key = nil|
      return @_local_store[namespace] if key.nil?

      @_local_store[namespace].fetch key
    end

    self.class.send :define_method, "#{namespace}_flush" do
      @_local_store[namespace] = {}
    end
  end

  # Create instance methods according to a namespace.
  # They are only proxy methods to class methods
  #
  # @api private
  #
  # @param namespace [Symbol, String]
  def create_instance_methods(namespace)
    define_method "#{namespace}_store" do |key, value|
      self.class.send "#{namespace}_store", key, value
    end

    define_method "#{namespace}_fetch" do |key = nil|
      self.class.send "#{namespace}_fetch", key
    end

    define_method "#{namespace}_flush" do
      self.class.send "#{namespace}_flush"
    end
  end
end

# https://6ftdan.com/allyourdev/2015/02/24/writing-methods-for-both-class-and-instance-levels/
# http://railstic.com/2011/06/dynamically-defining-methods-with-define_method/
# http://paulsturgess.co.uk/blog/2018/01/09/ruby-metaprogramming-define-method-and-instance-exec/
