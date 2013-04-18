should = require 'should'
helper = require './support/helper'
mongoHelper = require './support/mongo-helper'

describe 'store-test', ->
  before (done) ->
    helper.start null, done
  after ( done) ->
    helper.stop done

  describe 'WHEN accessing the store', ->
    it 'should return methods', (done)->
      storePackage = require '../lib/index'

      store = storePackage.store {}

      should.exist store

      done()

