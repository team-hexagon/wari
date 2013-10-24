(function() {
  var app, desktop, express, mkdirp;

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

  desktop = require("./desktop/app.js");

  app.use(express.vhost("*", desktop.active(52273)));

  app.listen(3000, function() {
    return log("super host is running on a port 52273");
  });

}).call(this);
