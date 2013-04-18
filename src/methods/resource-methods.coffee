_ = require 'underscore-ext'
PageResult = require('simple-paginator').PageResult
PageResultInfinite = require('simple-paginator').PageResultInfinite
errors = require 'some-errors'

mongoose = require "mongoose"
ObjectId = mongoose.Types.ObjectId

###
Provides methods to interact with resources.
###
module.exports = class ResourceMethods
  CREATE_FIELDS = ['_id','title','url','description','createdBy','tags']
  UPDATE_FIELDS = ['title','url','description','createdBy','tags']

  ###
  Initializes a new instance of the @see ResourceMethods class.
  @param {Object} models A collection of models that can be used.
  ###

  ###
  Initializes a new instance of the @see ResourceMethods class.
  @param {Object} models A collection of models that can be used.
  ###
  constructor:(@models) ->

  all: (options = {},cb = ->) =>
    @models.Resource.count  {}, (err, totalCount) =>
      return cb err if err
      options.offset or= 0
      options.count or= 100

      query = @models.Resource.find({})
      query.select(options.select) if options.select && options.select.length > 0
      query.setOptions { skip: options.offset, limit: options.count} if options.count or options.offset
      query.exec (err, items) =>
        return cb err if err
        cb null, new PageResult(items || [], totalCount, options.offset, options.count)

  ###
  Retrieve a single resource-item through it's id
  ###
  get: (resourceId, options = {}, cb = ->) =>
    resourceId = new ObjectId(resourceId.toString())
    query = @models.Resource.findOne _id : resourceId
    query = query.select(options.select) if options.select && options.select.length > 0
    query.exec cb


  ###
  Create a new resource
  ###
  create:(objs = {}, actor, cb = ->) =>
    data = {}
    data.createdBy = actor

    objs.tags = objs.states.split(',') if objs.tags && _.isString(objs.tags)

    _.extendFiltered data, CREATE_FIELDS, objs
    #return cb new errors.UnprocessableEntity("createdBy") unless data.createdBy && data.createdBy.actorId

    model = new @models.Resource(data)
    model.save (err) =>
      return cb err if err
      cb null, model,true


  destroy: (resourceId, options = {}, cb = ->) =>
    @_getItem resourceId, (err, item) =>
      return cb err if err
      return cb(null) unless item

      item.remove (err) =>
        return cb err if err
        cb null


  patch: (resourceId, obj = {}, options = {}, cb = ->) =>
    @_getItem resourceId, (err, item) =>
      return cb err if err
      return cb new errors.NotFound("/resources/#{resourceId}") unless item

      obj.states = obj.states.split(',') if obj.states && _.isString(obj.states)
      obj.captions = obj.captions.split(',') if obj.captions && _.isString(obj.captions)

      _.extendFiltered item, UPDATE_FIELDS, obj
      item.save (err) =>
        return cb err if err
        cb null, item

  put: (resourceId, obj = {}, options = {}, cb = ->) =>
    @_getItem resourceId, (err, item) =>
      return cb err if err
      return cb new errors.NotFound("/resources/#{resourceId}") unless item

      obj.states = obj.states.split(',') if obj.states && _.isString(obj.states)
      obj.captions = obj.captions.split(',') if obj.captions && _.isString(obj.captions)

      item[field] = null for field in UPDATE_FIELDS
      _.extendFiltered item, UPDATE_FIELDS, obj

      item.save (err) =>
        return cb err if err
        cb null, item

  _getItem: (resourceId, cb) =>
    resourceId = new ObjectId(resourceId.toString())
    @models.Resource.findOne _id : resourceId, cb
