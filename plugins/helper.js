(function() {
  var DISABLE_POST_INTERVAL, POST_INTERVAL, config;

  config = require("../config");

  POST_INTERVAL = config.postInterval;

  if (!(POST_INTERVAL > 0)) {
    POST_INTERVAL = 0;
  }

  DISABLE_POST_INTERVAL = POST_INTERVAL > 0 ? false : true;

  exports.adminRequired = function(request, response, next) {
    if (!request.session.user) {
      return response.render("notify/notify", {
        error: "로그인을 해주세요."
      });
    }
    if (!request.session.user.is_admin) {
      return response.render("notify/notify", {
        error: "관리자가 아닙니다."
      });
    }
    return next();
  };

  exports.userRequired = function(request, response, next) {
    if (!request.user) {
      return response.send(403);
    }
    return next();
  };

  exports.signinRequired = function(request, response, next) {
    if (!request.session.user) {
      return response.render("notify/notify", {
        error: "로그인 해주세요."
      });
    }
    return next();
  };

  exports.postInterval = function(request, response) {
    var ERROR_MSG;
    if (DISABLE_POST_INTERVAL) {
      return next();
    }
    if (isNaN(request.session.lastPostTimestamp)) {
      request.session.lastPostTimestamp = Date.now();
      return next();
    }
    if (Date.now() - request.session.lastPostTimestamp < POST_INTERVAL) {
      ERROR_MSG = "Plaease refresh webpage.";
      if (request.accepts("json")) {
        response.send({
          error: ERROR_MSG
        });
      } else {
        response.render("notify/notify", {
          error: ERROR_MSG
        });
      }
      return;
    }
    request.session.lastPostTimestamp = Date.now();
    return next();
  };

  exports.activeAccount = function(request, response, next) {};

}).call(this);
