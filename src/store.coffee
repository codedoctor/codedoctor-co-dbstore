mongoose = require 'mongoose'
_ = require 'underscore'
async = require 'async'

ResourceSchema = require './schemas/resource-schema'

ResourceMethods = require './methods/resource-methods'

module.exports = class Store
  constructor: (@settings = {}) ->
    _.defaults @settings, {}

    @models =
      Resource : mongoose.model "Resource",ResourceSchema

    @resources = new ResourceMethods @models

  ensureIndexes: (cb) =>
    stuff = []
    for k,model of @models
      stuff.push (cb) =>
        #winston.info "Index: #{JSON.stringify(idx)}" for idx in model.schema.indexes()
        model.ensureIndexes (err) =>
          winston.error "Ensuring index for #{model.modelName} - ERROR #{err}" if err
          cb null

    async.series stuff, cb
