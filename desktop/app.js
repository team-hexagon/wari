(function() {
  var app, everyauth, express, http, mkdirp, moment, path;

  express = require("express");

  http = require("http");

  path = require("path");

  mkdirp = require("mkdirp");

  moment = require("moment");

  everyauth = require("everyauth");

  everyauth.debug = true;

  config.uploadDir = config.uploadDir || path.join(__dirname, "public", "user_data", "images");

  mkdirp.sync(config.uploadDir);

  moment.lang("ja");

  app = express();

  require("../plugins/auth")(app);

  app.set("port", process.env.PORT || 3000);

  app.set("views", __dirname + "/views");

  app.set("view engine", "jade");

  app.use(express.favicon());

  app.use(express.logger("dev"));

  app.use(express.bodyParser({
    uploadDir: config.uploadDir
  }));

  app.use(express.cookieParser());

  app.use(express.session({
    secret: config.sessionSecret
  }));

  app.use(everyauth.middleware());

  app.use(express["static"](config.publicPath));

  app.use(function(request, response, next) {
    response.locals({
      path: request.path
    });
    return next();
  });

  app.use(app.router);

  if ("development" === app.get("env")) {
    app.use(express.errorHandler());
  }

  app.locals({
    config: config,
    moment: moment
  });

  require("./routes")(app);

  exports.active = function(port) {
    http.createServer(app).listen(port, function() {
      return console.log("Express server listening on port " + app.get("port"));
    });
    return app;
  };

}).call(this);
