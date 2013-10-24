exports.status = (request, response) ->
    response.send 
        status: "success"
        current: Date.now()