async = require 'async'

collections = ['resources']

module.exports = (mongo,databaseName,cb) ->
    console.log ""
    console.log "CLEANING Database #{databaseName}"

    removeCollection = (name,cb) ->
        #@mongo.collection(name).dropIndexes  (err) =>
        #console.log "COMPLETED DROP INDEXES ON #{name} ERR: #{err}"
        # NOTE: Drop Indexes reports errors on collections that don't exist...
        mongo.collection(name).remove {}, cb

    async.eachSeries collections ,removeCollection, (err) ->
      if err
        console.log "CLEANING Database #{databaseName} ERROR: #{err.message}"
      else
        console.log "CLEANING Database #{databaseName} COMPLETE"
      cb err
