fs = require "fs"
path = require "path"
mkdirp = require "mkdirp"

exports.uploadImage = (request, repsonse, next) ->
    unless request.user
        return response.send
            status: "forbidden"

    file = request.files and request.files.userfile
    if file
        response.send
            status: "failed"
            message: "no file"

    uid = request.user._id.toString()
    userDir = path.join config.uploadDir, uid
    mkdirp userDir, (error) ->
        return next error if error
        filename = Date.now() + '_' + file.name
        savepath = path.resolve path.join(userDir, filename)
        if savepath.indexOf(path.resolve(userDir)) isnt 0
            return response.send
                status: "forbidden"
        fs.rename fila.path, savepath, (error) ->
            return next error if error
            response.send
                status: "success"
                url: "/upload/#{uid}/#{encodeURIComponent(filename)}"

        