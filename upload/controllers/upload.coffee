fs = require "fs"
path = require "path"
mkdirp = require "mkdirp"

exports.browseImage = (request, response, next) ->
    

exports.uploadImage = (request, response, next) ->
    log "upload start"
    ###
    unless request.user
    return response.send
    status: "forbidden"
    ###
    ckEditorFuncNum = request.param "CKEditorFuncNum"
    file = request.files and request.files.upload
    unless file
        return response.send
            status: "failed"
            message: "no file"
    # uid = request.user._id.toString()
    userDir = config.uploadDir #path.join config.uploadDir, uid
    mkdirp userDir, (error) ->
        return next error if error
        filename = "#{Date.now()}_#{file.name}"
        savepath = path.resolve path.join(userDir, filename)
        if savepath.indexOf(path.resolve(userDir)) isnt 0
            return response.send
                status: "forbidden"
        fs.rename file.path, savepath, (error) ->
            return next error if error
            url = "/upload/#{encodeURIComponent(filename)}"
            response.send """
            <script>
                document.domain = '127.0.0.1.xip.io';
                window.parent.CKEDITOR.tools.callFunction('#{ckEditorFuncNum}','#{url}','Success');
            </script>
            """
        #status: "success"
        #url: "http://upload.127.0.0.1.xip.io:3000/upload/#{encodeURIComponent(filename)}"
        ###
        