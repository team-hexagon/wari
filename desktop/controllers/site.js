(function() {
  var EventProxy, log, _;

  EventProxy = require("eventproxy");

  _ = require("underscore");

  /*
  User = require("../models").User
  Topic = require("../models").Topic
  Tag = require("../models").Tag
  */


  log = console.log;

  exports.index = function(request, response, next) {
    var keyword, limit, page;
    page = parseInt(request.param("page"), 10) || 1;
    keyword = request.param("keyword");
    limit = config.listTopicCount;
    log("site");
    return response.render("index");
    /*
        success = (tags, topics, hotTopics, stars, tops, noReplyTopics, pages) ->
            log arguments
    
        # 프록시를 생성합니다.
        proxy = EventProxy.create("tags", "topics", "hotTopics", "stars", "tops", "noReplyTopics", "pages", success)
        proxy.fail(next)
    
        # 태그
        Tag.getAllTags(proxy.done("tags"))
    
        # 토픽
        query = {}
        if keyword
            keyword = keyword.join(" ") if Array.isArray(keyword)
            keyword.trim()
            keyword = keyword.replace(/[\*\^\&\(\)\[\]\+\?\\]/g, "")
            query.title = new RegExp(keyword, "i")
        Topic.getTopicsByQuery(query, {
            skip: (page - 1) * limit
            limit: limit
            sort: [
                ["top", "desc"]
                ["last_reply_at", "desc"]
            ]
        }, proxy.done("topics"))
    
        # 인기 토픽
        Topic.getTopicByQuery({}, {
            limit: 5
            sort: [
                ["visit_count", "desc"]    
            ]
        }, proxy.done("hotTopics"))
    
        # 별 사용자
        User.getUsersByQuery({
            is_star: true
        }, {
            limit: 5
        }, proxy.done("stars"))
    
        # 인기 사용자
        User.getUsersByQuery({}, {
            limit: 10
            sort: [
                ["score", "desc"]
            ]
        }, proxy.done("tops"))
    
        # 댓글 없는 토픽
        Topic.getTopicsByQuery({
            reply_count: 0
        }, {
            limit: 5
            sort: [
                ["create_at", "desc"]
            ]
        }, proxy.done("noReplyTopics"))
    
        # 페이지
        Topic.getCountByQuery(query, proxy.done((allTopicsCount) ->
            pages = Math.ceil(allTopicsCount / limit)
            proxy.emit("pages", pages)
        ))
    */

  };

}).call(this);
