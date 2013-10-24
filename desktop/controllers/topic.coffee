# 모듈을 추출합니다.
validator = require "validator"
EventProxy = require "eventproxy"
moment = require "moment"

# 함수를 추출합니다.
sanitize = validator.sanitize
User = models.User
Topic = models.Topic
Tag = models.Tag
Relation = models.Ralation
TopicTag = models.TopicTag
TopicCollect = models.TopicCollect

# 모듈을 생성합니다.
exports.index = (request, response, next) ->
    # 요청 매개 변수를 추출합니다.
    topicId = request.param "tid"
    unless topicId.length is 24
        response.render "notify/notify",
            error: "non valid tag"

    # topic 검색
    query = Topic.findOne
        _id: topicId
    query.populate "_tag"
    query.populate "_author"
    query.exec (error, topic) ->
        # 오류 검사
        return next error unless topic
        if error
            proxy.unbind()
            return response.render "notify/notify"
                error: error

        # 프록시를 생성합니다.
        events = ["otherTopics", "noReplyTopics"]
        proxy = EventProxy.create events, (otherTopics, noReplyTopics) ->
            response.render "#{topic._tag.menu_template}/topic",
                topic: topic
        proxy.fail next

        # other topic
        Topic.find {
            author_id: topic.author_id
            _id:
                $nin: [topic._id]
        }, null, {
            limit: 5
            sort: [
                ["last_reply_at", "desc"]
            ]
        }, proxy.done("otherTopics")

        # noreply
        Topic.find {
            reply_count: 0
        }, null, {
            limit: 5
            sort: [
                ["created_at", "desc"]
            ]
        }, proxy.done("noReplyTopics")

exports.create = (request, response, next) ->
    # 요청 매개 변수를 추출합니다.
    tagName = request.param "tagName"
    Tag.findOne { name: tagName }, {}, {
        sort: [
            ["order", "asc"]
        ]
    }, (error, tag) ->
        log tag
        return next(error) if error
        response.render "topic/edit",
            tag: tag

exports.put = (request, response, next) ->
    # 요청 매개 변수를 추출합니다.
    tagName = request.param "tagName"
    title = request.param "title"
    title = sanitize(title).trim()
    title = sanitize(title).xss()
    content = request.param "content"

    # 태그를 추출합니다.
    Tag.getTagByName tagName, (error, tag) ->
        return next error if error
        log tag
        tag.ancestors.push tag._id
        
        # 글을 생성합니다: _tag는 현재 태그
        log request.user
        topic = new Topic
            title: title
            content: content
            _author: request.user._id
            _tag: tag._id

        # 저장합니다.
        topic.save (error) ->
            # 오류
            return next error if error
        
            # 프록시를 생성합니다.
            proxy = new EventProxy
            proxy.assign ["tagSave", "scoreSave"], () ->
                response.redirect "/topic/#{topic._id}"
            proxy.fail(next)

            # 태그 추가
            proxy.after "tagSave", tag.ancestors.length, () ->
                proxy.emit "tagSave"
            tag.ancestors.forEach (tag_id) ->
                topicTag = new TopicTag
                    _topic: topic._id
                    _tag: tag_id
                topicTag.save proxy.done("tagSave")
                Tag.findById tag_id, proxy.done (tag) ->
                    tag.topic_count += 1
                    tag.save()

            # 사용자 점수 추가
            User.findById request.user._id, proxy.done (user) ->
                user.score += 5
                user.topic_count += 1
                request.user.score += 5
                user.save proxy.done("scoreSave")

exports.showEdit = (request, response, next) ->
exports.update = (request, response, next) ->
exports.del = (request, response, next) ->
exports.top = (request, response, next) ->
exports.collect = (request, response, next) ->
    # 요청 매개 변수를 추출합니다.
    tagName = request.param "tagName"
    topicId = request.param "topic-id"

    # 데이터를 추가합니다.
    Topic.findById topicId, (error, topic) ->
        return next error if error
        return response.send { error: "no topic" } unless topic
        

exports.decollect = (request, response, next) ->