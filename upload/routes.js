(function() {
  var upload;

  upload = require("./controllers/upload");

  module.exports = function(app) {
    return app.post("/images", upload.uploadImage);
  };

}).call(this);
