(function() {
  var ObjectId, Schema, TopicCollect, TopicCollectSchema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  ObjectId = Schema.ObjectId;

  TopicCollectSchema = new Schema({
    _user: {
      type: ObjectId,
      required: true,
      ref: "User"
    },
    _topic: {
      type: ObjectId,
      required: true,
      ref: "Topic"
    },
    create_at: {
      type: Date,
      "default": Date.now
    }
  });

  TopicCollect = mongoose.model("TopicCollect", TopicCollectSchema);

  TopicCollect.getTopicCollect = function(userId, topicId, callback) {
    return TopicCollect.findOne({
      _user: userId,
      _topic: topicId
    }, callback);
  };

  TopicCollect.getTopicCollectByUserId = function(userId, callback) {
    return TopicCollect.find({
      _user: userId
    }, callback);
  };

  module.exports = TopicCollect;

}).call(this);
