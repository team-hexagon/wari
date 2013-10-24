(function() {
  var config, log, mongoose;

  mongoose = require("mongoose");

  config = require("../config");

  log = console.log;

  mongoose.connect(config.db, function(error) {
    if (error) {
      console.error("connect to " + config.db);
      return process.exit(1);
    }
  });

  exports.User = require("./user");

  exports.Topic = require("./topic");

  exports.Tag = require("./tag");

  exports.TopicTag = require("./topicTag");

  exports.TagCollect = require("./tagCollect");

  exports.Reply = require("./reply");

  /*
  exports.TopicCollect = require "./topicCollect" 
  exports.Relation = mongoose.model "./relation" 
  exports.Message = mongoose.model "./message"
  */


}).call(this);
