(function() {
  var EventProxy, ObjectId, Schema, Topic, TopicSchema, log, mongoose;

  mongoose = require("mongoose");

  EventProxy = require("eventproxy");

  Schema = mongoose.Schema;

  ObjectId = Schema.ObjectId;

  log = console.log;

  TopicSchema = new Schema({
    title: {
      type: String,
      required: true
    },
    content: {
      type: String,
      required: true
    },
    _author: {
      type: ObjectId,
      ref: "User",
      required: true
    },
    _tag: {
      type: ObjectId,
      ref: "Tag",
      required: true
    },
    top: {
      type: Boolean,
      "default": false
    },
    reply_count: {
      type: Number,
      "default": 0
    },
    visit_count: {
      type: Number,
      "default": 0
    },
    collect_count: {
      type: Number,
      "default": 0
    },
    create_at: {
      type: Date,
      "default": Date.now
    },
    update_at: {
      type: Date,
      "default": Date.now
    },
    _last_reply: {
      type: ObjectId,
      ref: "Reply"
    },
    last_reply_at: {
      type: Date,
      "default": Date.now
    },
    content_is_html: {
      type: Boolean
    }
  });

  Topic = mongoose.model("Topic", TopicSchema);

  Topic.getTopicById = function(id, calback) {
    return Topic.findOne({
      _id: id
    }).populate("_author").populate("_last_reply").exec(function(error, topic) {
      if (error) {
        return callback(error);
      }
      if (!topic) {
        return callback(null, null, []);
      }
      return TopicTag.find({
        _topic: topic._id
      }).populate("_topic".exec(function(error, tags) {
        return callback(null, topic, tags);
      }));
    });
  };

  Topic.updateLastReply = function(topicId, replyId, callback) {
    return Topic.findOne({
      _id: topicId
    }, function(error, topic) {
      if (error) {
        return callback(error);
      }
      topic._last_reply = replyId;
      topic.last_reply_at = new Date();
      topic.reply_count += 1;
      return topic.save(callback);
    });
  };

  Topic.reduceReply = function(id, callback) {
    return Topic.findOne({
      _id: id
    }, function(erorr, topic) {
      if (error) {
        return callback(error);
      }
      if (!topic) {
        return callback(new Error("No Reply"));
      }
      topic.reply_count -= 1;
      return topic.save(callback);
    });
  };

  module.exports = Topic;

}).call(this);
