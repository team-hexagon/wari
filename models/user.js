(function() {
  var Schema, User, UserSchema, config, log, mongoose;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  config = require("../config");

  log = console.log;

  UserSchema = new Schema({
    name: {
      type: String,
      index: true
    },
    login: {
      type: String,
      unique: true
    },
    password: {
      type: String
    },
    email: {
      type: String,
      unique: true
    },
    url: {
      type: String
    },
    profile_image_url: {
      type: String
    },
    location: {
      type: String
    },
    signature: {
      type: String
    },
    profile: {
      type: String
    },
    avatar: {
      type: String
    },
    score: {
      type: Number,
      "default": 0
    },
    topic_count: {
      type: Number,
      "default": 0
    },
    reply_count: {
      type: Number,
      "default": 0
    },
    follower_count: {
      type: Number,
      "default": 0
    },
    following_count: {
      type: Number,
      "default": 0
    },
    collect_tag_count: {
      type: Number,
      "default": 0
    },
    collect_topic_count: {
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
    is_star: {
      type: Boolean
    },
    level: {
      type: String
    },
    active: {
      type: Boolean,
      "default": true
    },
    receive_reply_mail: {
      type: Boolean,
      "default": false
    },
    receive_at_mail: {
      type: Boolean,
      "default": false
    },
    from_wp: {
      type: Boolean
    },
    retrieve_time: {
      type: Number
    },
    retrieve_key: {
      type: String
    }
  });

  UserSchema.virtual("avatar_url").get(function() {
    var url;
    url = "" + (this.profile_image_url || this.avatar || config.site_static_host) + "/public/images/user_icon&48.png";
    return url.replace("http://www.gravatar.com/", "http://gravatar.qiniudn.com/");
  });

  User = mongoose.model("User", UserSchema);

  User.getUsersByNames = function(names, callback) {
    if (names.length === 0) {
      return callback(null, []);
    }
    return User.find({
      name: {
        $in: names
      }
    }, callback);
  };

  User.getUserByLogin = function(login, callback) {
    return User.findOne({
      login: login
    }, callback);
  };

  User.getUserById = function(id, callback) {
    return User.findOne({
      _id: id
    }, callback);
  };

  User.getUserByName = function(name, callback) {
    return User.findOne({
      name: name
    }, callback);
  };

  User.getUserByMail = function(email, callback) {
    return User.findOne({
      email: email
    }, callback);
  };

  User.getUsersByIds = function(ids, callback) {
    return User.find({
      _id: {
        $in: ids
      }
    }, callback);
  };

  User.getUsersByQuery = function(query, option, callback) {
    return User.find(query, [], option, callback);
  };

  User.getUserByQuery = function(query, option, callback) {
    return User.findOne(query, [], option, callback);
  };

  module.exports = User;

}).call(this);
