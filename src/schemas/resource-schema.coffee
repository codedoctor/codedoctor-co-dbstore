_ = require 'underscore'
mongoose = require 'mongoose'
pluginTimestamp = require "mongoose-plugins-timestamp"
pluginCreatedBy = require "mongoose-plugins-created-by"
pluginTagsSimple = require "mongoose-plugins-tags-simple"
pluginAccessibleBy = require "mongoose-plugins-accessible-by"
errors = require 'some-errors'
ObjectId = mongoose.Schema.ObjectId

module.exports = ResourceSchema = new mongoose.Schema
      title:
        type: String
        required: true
      url:
        type: String
        required: true
      description:
        type: String

    , strict: true


ResourceSchema.plugin pluginTimestamp.timestamps
ResourceSchema.plugin pluginCreatedBy.createdBy, isRequired : true
ResourceSchema.plugin pluginTagsSimple.tagsSimple
ResourceSchema.plugin pluginAccessibleBy.accessibleBy, defaultIsPublic : true

###
RoleSchema.pre 'save', (next) ->
  @name = (@name || '').toLowerCase()

  next()
###
