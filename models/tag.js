(function() {
  var ObjectId, Schema, Tag, TagSchema, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  ObjectId = Schema.Types.ObjectId;

  TagSchema = new Schema({
    name: {
      type: String,
      required: true
    },
    order: {
      type: Number,
      "default": 1
    },
    description: {
      type: String
    },
    menu_template: {
      type: String,
      required: true
    },
    topic_count: {
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
    ancestors: {
      type: [
        {
          type: ObjectId,
          ref: "Tag"
        }
      ],
      "default": []
    }
  });

  Tag = mongoose.model("Tag", TagSchema);

  Tag.getTagById = function(id, callback) {
    return Tag.findById(id, callback);
  };

  Tag.getTagByName = function(name, callback) {
    return Tag.findOne({
      name: name
    }, callback);
  };

  Tag.getTagsByIds = function(ids, callback) {
    return Tag.findOne({
      _id: {
        $in: ids
      }
    }, callback);
  };

  Tag.getAllTags = function(callback) {
    return Tag.find({}, null, {
      sort: [["order", "asc"]]
    }, callback);
  };

  module.exports = Tag;

}).call(this);
