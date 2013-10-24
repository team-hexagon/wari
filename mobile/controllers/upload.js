(function() {
  var fs, mkdirp, path;

  fs = require("fs");

  path = require("path");

  mkdirp = require("mkdirp");

  exports.uploadImage = function(request, repsonse, next) {
    var file, uid, userDir;
    if (!request.user) {
      return response.send({
        status: "forbidden"
      });
    }
    file = request.files && request.files.userfile;
    if (file) {
      response.send({
        status: "failed",
        message: "no file"
      });
    }
    uid = request.user._id.toString();
    userDir = path.join(config.uploadDir, uid);
    return mkdirp(userDir, function(error) {
      var filename, savepath;
      if (error) {
        return next(error);
      }
      filename = Date.now() + '_' + file.name;
      savepath = path.resolve(path.join(userDir, filename));
      if (savepath.indexOf(path.resolve(userDir)) !== 0) {
        return response.send({
          status: "forbidden"
        });
      }
      return fs.rename(fila.path, savepath, function(error) {
        if (error) {
          return next(error);
        }
        return response.send({
          status: "success",
          url: "/upload/" + uid + "/" + (encodeURIComponent(filename))
        });
      });
    });
  };

}).call(this);
