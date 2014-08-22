restify = require 'restify'
require 'coffee-script/register'
redis = require './redis'

server = restify.createServer name: 'simplekeyval'

server.pre restify.pre.userAgentConnection()
server.use restify.bodyParser()

server.post '/:key', redis.setValue
server.get '/:key', redis.getValue

server.listen 8080, ->
        console.log '%s Listening at %s', server.name, server.url
