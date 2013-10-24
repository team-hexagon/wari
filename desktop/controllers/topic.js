(function() {
  var EventProxy, Relation, Tag, Topic, TopicCollect, TopicTag, User, moment, sanitize, validator;

  validator = require("validator");

  EventProxy = require("eventproxy");

  moment = require("moment");

  sanitize = validator.sanitize;

  User = models.User;

  Topic = models.Topic;

  Tag = models.Tag;

  Relation = models.Ralation;

  TopicTag = models.TopicTag;

  TopicCollect = models.TopicCollect;

  exports.index = function(request, response, next) {
    var query, topicId;
    topicId = request.param("tid");
    if (topicId.length !== 24) {
      response.render("notify/notify", {
        error: "non valid tag"
      });
    }
    query = Topic.findOne({
      _id: topicId
    });
    query.populate("_tag");
    query.populate("_author");
    return query.exec(function(error, topic) {
      var events, proxy;
      if (!topic) {
        return next(error);
      }
      if (error) {
        proxy.unbind();
        return response.render("notify/notify", {
          error: error
        });
      }
      events = ["otherTopics", "noReplyTopics"];
      proxy = EventProxy.create(events, function(otherTopics, noReplyTopics) {
        return response.render("" + topic._tag.menu_template + "/topic", {
          topic: topic
        });
      });
      proxy.fail(next);
      Topic.find({
        author_id: topic.author_id,
        _id: {
          $nin: [topic._id]
        }
      }, null, {
        limit: 5,
        sort: [["last_reply_at", "desc"]]
      }, proxy.done("otherTopics"));
      return Topic.find({
        reply_count: 0
      }, null, {
        limit: 5,
        sort: [["created_at", "desc"]]
      }, proxy.done("noReplyTopics"));
    });
  };

  exports.create = function(request, response, next) {
    var tagName;
    tagName = request.param("tagName");
    return Tag.findOne({
      name: tagName
    }, {}, {
      sort: [["order", "asc"]]
    }, function(error, tag) {
      log(tag);
      if (error) {
        return next(error);
      }
      return response.render("topic/edit", {
        tag: tag
      });
    });
  };

  exports.put = function(request, response, next) {
    var content, tagName, title;
    tagName = request.param("tagName");
    title = request.param("title");
    title = sanitize(title).trim();
    title = sanitize(title).xss();
    content = request.param("content");
    return Tag.getTagByName(tagName, function(error, tag) {
      var topic;
      if (error) {
        return next(error);
      }
      log(tag);
      tag.ancestors.push(tag._id);
      log(request.user);
      topic = new Topic({
        title: title,
        content: content,
        _author: request.user._id,
        _tag: tag._id
      });
      return topic.save(function(error) {
        var proxy;
        if (error) {
          return next(error);
        }
        proxy = new EventProxy;
        proxy.assign(["tagSave", "scoreSave"], function() {
          return response.redirect("/topic/" + topic._id);
        });
        proxy.fail(next);
        proxy.after("tagSave", tag.ancestors.length, function() {
          return proxy.emit("tagSave");
        });
        tag.ancestors.forEach(function(tag_id) {
          var topicTag;
          topicTag = new TopicTag({
            _topic: topic._id,
            _tag: tag_id
          });
          topicTag.save(proxy.done("tagSave"));
          return Tag.findById(tag_id, proxy.done(function(tag) {
            tag.topic_count += 1;
            return tag.save();
          }));
        });
        return User.findById(request.user._id, proxy.done(function(user) {
          user.score += 5;
          user.topic_count += 1;
          request.user.score += 5;
          return user.save(proxy.done("scoreSave"));
        }));
      });
    });
  };

  exports.showEdit = function(request, response, next) {};

  exports.update = function(request, response, next) {};

  exports.del = function(request, response, next) {};

  exports.top = function(request, response, next) {};

  exports.collect = function(request, response, next) {
    var tagName, topicId;
    tagName = request.param("tagName");
    topicId = request.param("topic-id");
    return Topic.findById(topicId, function(error, topic) {
      if (error) {
        return next(error);
      }
      if (!topic) {
        return response.send({
          error: "no topic"
        });
      }
    });
  };

  exports.decollect = function(request, response, next) {};

}).call(this);
