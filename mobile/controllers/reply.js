(function() {
  var EventProxy, Reply, Topic, User, santitize, validator;

  validator = require("validator");

  EventProxy = require("eventproxy");

  santitize = validator.santitize;

  User = models.User;

  Topic = models.Topic;

  Reply = models.Reply;

  exports.add = function(request, response, next) {};

  exports.addReply2 = function(request, response, next) {};

  exports.del = function(request, response, next) {};

}).call(this);
