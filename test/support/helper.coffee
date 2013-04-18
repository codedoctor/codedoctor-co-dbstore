mongoskin = require 'mongoskin'
mongoose = require 'mongoose'
_ = require 'underscore'

ObjectId = require('mongoose').Types.ObjectId
Index = require '../../lib/index'

cleanDatabase = require './clean-database'

class Helper
  database: 'mongodb://localhost/codedoctor-co-dbstore'
  store: null

  start: (obj = {}, done) =>
    @mongo = mongoskin.db @database, safe:true

    stuff = []

    # mongoose.set('debug', true)
    @store or= Index.store()

    cleanDatabase @mongo,@database, (err) =>
      return done err if err

      mongoose.connect @database

      @store.ensureIndexes (err) =>
        return done err if err
        done null

  stop: (done) =>
    mongoose.disconnect =>
      @mongo.close (err) =>
        @mongo = null
        done()


module.exports = new Helper()
