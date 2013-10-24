(function() {
  var EventProxy, Tag, TagCollect, Topic, TopicTag, User, log, sanitize, validator;

  validator = require("validator");

  EventProxy = require("eventproxy");

  log = console.log;

  sanitize = validator.sanitize;

  Topic = models.Topic;

  Tag = models.Tag;

  TagCollect = models.TagCollect;

  TopicTag = models.TopicTag;

  User = models.User;

  exports.listTopic = function(request, response, next) {
    var limit, page, tagName;
    tagName = request.param("name");
    page = request.param("page");
    page = page || 1;
    limit = config.listTopicCount;
    return Tag.getTagByName(tagName, function(error, tag) {
      var done, events, proxy, style;
      if (error) {
        return next(error);
      }
      if (!tag) {
        return response.render("notify/notify", {
          error: "no exists tag"
        });
      }
      style = tag.background ? "#wrapper {background-image: url('" + tag.background + "')}" : null;
      done = function(pages, topics, collection, hotTopics, noReplyTopics) {
        return response.render("" + tag.menu_template + "/index", {
          tag: tag,
          topics: topics,
          currentPage: page,
          listTopicCount: limit,
          inCollection: collection,
          hotTopics: hotTopics,
          noReplyTopics: noReplyTopics,
          pages: pages,
          extraStyle: style
        });
      };
      proxy = new EventProxy();
      events = ["pages", "topics"];
      proxy.assign(events, done);
      TopicTag.count({
        _tag: tag._id
      }, function(error, count) {
        var pages;
        pages = Math.ceil(count / limit);
        return proxy.emit("pages", pages);
      });
      return TopicTag.find({
        _tag: tag._id
      }, null, {
        skip: (page - 1) * limit,
        limit: limit,
        sort: [["create_at", "desc"]]
      }, function(error, topicTags) {
        var query;
        query = Topic.find({
          _id: {
            $in: topicTags.map(function(item) {
              return item._topic;
            })
          }
        });
        query.sort({
          "create_at": "desc"
        });
        return query.populate("_author", "login").populate("_tag", "name").exec(proxy.done("topics"));
      });
    });
  };

  exports.editTags = function(request, response, next) {
    return Tag.getAllTags(function(error, tags) {
      return response.render("tags/editAll", {
        tags: tags
      });
    });
  };

  exports.add = function(request, response, next) {
    var description, menuTemplate, name, order;
    name = request.param("name");
    name = sanitize(name).trim();
    name = sanitize(name).xss();
    description = request.param("description");
    description = sanitize(description).trim();
    description = sanitize(description).xss();
    menuTemplate = request.param("menu-template");
    menuTemplate = sanitize(menuTemplate).trim();
    menuTemplate = sanitize(menuTemplate).xss();
    order = request.param("order");
    if (!name) {
      return response.render("notify/notify", {
        error: "이름이 없엉"
      });
    }
    return Tag.getTagByName(name, function(error, tags) {
      var tag;
      if (error) {
        return next(error);
      }
      if (tags && tags.length > 0) {
        return response.render("notify/notify", {
          error: "이미 있엉"
        });
      }
      tag = new Tag({
        name: name,
        menu_template: menuTemplate,
        order: order,
        description: description
      });
      return tag.save(function(error) {
        if (error) {
          return next(error);
        }
        return response.redirect("/tags/edit");
      });
    });
  };

  exports.edit = function(request, response, next) {
    var tagName;
    tagName = request.param("name");
    return Tag.getTagByName(tagName, function(error, tag) {
      if (error) {
        return next(error);
      }
      if (!tag) {
        return response.render("notify/notify", {
          error: "존재하지 않는 태그입니다."
        });
      }
      return Tag.getAllTags(function(error, tags) {
        if (error) {
          return next(error);
        }
        return response.render("tags/edit", {
          tag: tag,
          tags: tags
        });
      });
    });
  };

  exports.update = function(request, response, next) {
    var id;
    id = request.param("id");
    return Tag.getTagById(id, function(error, tag) {
      var description, menuTemplate, name, order;
      if (error) {
        return next(error);
      }
      if (!tag) {
        return response.render("notify/notify", {
          error: "존재하지 않는 태그입니다."
        });
      }
      name = request.param("name");
      name = sanitize(name).trim();
      name = sanitize(name).xss();
      order = request.param("order");
      menuTemplate = request.param("menu-template");
      menuTemplate = sanitize(menuTemplate).trim();
      menuTemplate = sanitize(menuTemplate).xss();
      description = request.param("description");
      description = sanitize(description).trim();
      description = sanitize(description).xss();
      if (!name) {
        return response.send("notify/notify", {
          error: "이름이 이상해요"
        });
      }
      tag.name = name;
      tag.order = order;
      tag.menu_template = menuTemplate;
      tag.description = description;
      return tag.save(function(error) {
        if (error) {
          return next(error);
        }
        response.redirect("/tags/edit");
        return log(tag);
      });
    });
  };

  exports.del = function(request, response, next) {
    var done, proxy, tagName;
    tagName = request.param("name");
    Tag.getTagByName(tagName, function(error, tag) {
      if (error) {
        return next(error);
      }
      if (!tag) {
        return response.render("notify/notify", {
          error: "존재하지 않는 태그입니다."
        });
      }
    });
    proxy = new EventProxy();
    done = function() {
      return tag.remove(function(error) {
        if (error) {
          return next(error);
        }
        return response.redirect("/");
      });
    };
    proxy.assign("topicTagRemoved", "tagCollectRemoved", done);
    proxy.fail(next);
    TopicTag.removeByTagId(tag._id, proxy.done("topicTagRemoved"));
    return TagCollect.removeAllByTagId(tag._id, proxy.done("tagCollectRemoved"));
  };

  exports.collect = function(request, response, next) {};

  exports.decollect = function(request, response, next) {};

}).call(this);
