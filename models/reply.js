(function() {
  var ObjectId, Reply, ReplySchema, Schema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  ObjectId = Schema.ObjectId;

  ReplySchema = new Schema({
    content: {
      type: String
    },
    _topic: {
      type: ObjectId,
      index: true
    },
    _author: {
      type: ObjectId,
      ref: "User"
    },
    _reply: {
      type: ObjectId,
      ref: "Reply"
    },
    create_at: {
      type: Date,
      "default": Date.now
    },
    update_at: {
      type: Date,
      "default": Date.now
    },
    content_is_html: {
      type: Boolean
    }
  });

  Reply = mongoose.model("Reply", ReplySchema);

  Reply.getReplyById = function(id, callback) {
    return Reply.findOne({
      _id: id
    }).populate('_author').populate('_reply').exec(callback);
  };

  Reply.getRepliesByTopicId = function(id, callback) {
    return Reply.find({
      _topic: id
    }, [], {
      sort: [["created_at", "asc"]]
    }).populate("_author").exec(callback);
  };

  exports.getRepliesByAuthorId = function(id, callback) {
    return Reply.find({
      _author: id
    }, callback);
  };

  module.exports = Reply;

}).call(this);
