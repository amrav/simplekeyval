if process.env.REDISTOGO_URL
        rtg = require('url').parse process.env.REDISTOGO_URL
        redis = require('redis').createClient rtg.port, rtg.hostname
        redis.auth rtg.auth.split(':')[1]
else
        redis = require('redis').createClient()

redis.on 'connect', ->
        console.log 'Connected to Redis'

exports.setValue = (req, res, next) ->
        console.log 'Setting value for key %s', req.params.key
        redis.HGETALL req.params.key, (err, hash) ->

                console.log "Retrieved hash: ", hash

                if not hash?
                        console.log('No value set for key')

                else if hash.readOnly is 'true' and req.params.secret isnt hash.secret
                        console.log('Key is read only')
                        res.send 403
                        return next()

                value = val: req.params.val
                if req.params.readOnly? and req.params.secret?
                        value.readOnly = req.params.readOnly
                        value.secret = req.params.secret

                redis.HMSET req.params.key, value, ->
                        console.log('Set val', value)
                        res.send 200
                        # Expire keys after 6 months
                        redis.EXPIRE req.params.key, 6 * 30 * 24 * 3600
                        return next()

exports.getValue = (req, res, next) ->
        console.log 'Asking for value of key %s', req.params.key
        redis.HGET req.params.key, 'val', (err, val) ->
                if err
                        res.send(500)
                        return next()

                if val?
                        res.send {key: req.params.key, val: val}
                else
                        res.send 404, 'key not found'

                console.log 'Response from redis: %s', val
                return next()
