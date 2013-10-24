(function() {
  var ObjectId, Schema, TopicTag, TopicTagSchema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  ObjectId = Schema.ObjectId;

  TopicTagSchema = new Schema({
    _topic: {
      type: ObjectId,
      required: true,
      ref: "Topic"
    },
    _tag: {
      type: ObjectId,
      required: true,
      ref: "Tag"
    },
    create_at: {
      type: Date,
      "default": Date.now
    }
  });

  TopicTag = mongoose.model("TopicTag", TopicTagSchema);

  TopicTag.getTopicTagByTagId = function(id, callback) {
    return TopicTag.find({
      tag_id: id
    }, callback);
  };

  TopicTag.getTopicTagByTopicId = function(id, callback) {
    return TopicTag.find({
      topic_id: id
    }, callback);
  };

  TopicTag.removeByTagId = function(id, callback) {
    return TopicTag.remove({
      tag_id: id
    }, callback);
  };

  module.exports = TopicTag;

}).call(this);
