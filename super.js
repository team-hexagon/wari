(function() {
  var app, desktop, express, mkdirp, upload;

  express = require("express");

  mkdirp = require("mkdirp");

  global.log = console.log;

  global.config = require("./config");

  global.models = require("./models");

  global.proxy = require("./proxy");

  global.auth = require("./plugins/auth");

  global.helper = require("./plugins/helper");

  mkdirp.sync(config.uploadDir);

  app = express();

  upload = require("./upload/app.js");

  desktop = require("./desktop/app.js");

  app.use(express.vhost("upload.*", upload.active(52274)));

  app.use(express.vhost("*", desktop.active(52273)));

  app.listen(3000, function() {
    return log("super host is running on a port 52273");
  });

}).call(this);
