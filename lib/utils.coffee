Request = require 'request'

# HTTP request wrapped in a Promise
exports.request = (params) ->
    new Promise (done, fail) ->
        Request params, (err, resp, data) ->
            console.log err, resp, data
            if err?
                fail err
            else if resp.statusCode != 200
                fail new Error "Unexpected HTTP #{resp.statusCode}"
            else
                done data
