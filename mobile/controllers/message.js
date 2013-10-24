(function() {
  var EventProxy, Message;

  EventProxy = require("eventproxy");

  Message = models.Message;

  exports.index = function(request, response, next) {
    var message_ids, user_id;
    if (!request.user) {
      response.redirect("home");
    }
    message_ids = [];
    return user_id = request.user._id;
  };

  exports.markRead = function(request, response, next) {};

  exports.markAllRead = function(request, response, next) {};

}).call(this);
