(function() {
  var EventProxy, Relation, Reply, Tag, TagCollect, Topic, TopicCollect, User, check, crypto, moment, santitize, validator;

  validator = require("validator");

  EventProxy = require("eventproxy");

  moment = require("moment");

  crypto = require("crypto");

  santitize = validator.santitize;

  check = validator.check;

  User = models.User;

  Tag = models.Tag;

  Topic = models.Topic;

  Reply = models.Reply;

  Relation = models.Relation;

  TopicCollect = models.TopicCollect;

  TagCollect = models.TagCollect;

  exports.index = function(request, response, next) {};

  exports.showStars = function(request, response, next) {};

  exports.showSetting = function(request, response, next) {};

  exports.setting = function(request, response, next) {};

  exports.follow = function(request, response, next) {};

  exports.unFollow = function(request, response, next) {};

  exports.toggleStar = function(request, response, next) {};

  exports.getCollectTags = function(request, response, next) {};

  exports.getCollectTopics = function(request, response, next) {};

  exports.getFollowings = function(request, response, next) {};

  exports.getFollowers = function(request, response, next) {};

  exports.top100 = function(request, response, next) {};

  exports.listTopics = function(request, response, next) {};

  exports.listReplies = function(request, response, next) {};

}).call(this);
