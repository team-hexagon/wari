# 모듈을 추출합니다.
validator = require "validator"
EventProxy = require "eventproxy"

# 함수를 추출합니다.
log = console.log
sanitize = validator.sanitize
Topic = models.Topic
Tag = models.Tag
TagCollect = models.TagCollect
TopicTag = models.TopicTag
User = models.User

initString = (input) -> sanitize(sanitize(input).trim()).xss()

# 모듈을 생성합니다.
exports.listTopic = (request, response, next) ->
    # 요청 매개 변수를 추출합니다.
    tagName = request.param "name"
    page = request.param "page"
    page = page or 1
    limit = config.listTopicCount

    # 태그 추출
    Tag.getTagByName tagName, (error, tag) ->
        # 오류 검사
        return next error if error
        unless tag
            return response.render "notify/notify",
                error: "no exists tag"

        # 변수를 선언합니다.
        style = if tag.background then "#wrapper {background-image: url('#{tag.background }')}" else null

        # 프록시를 생성합니다.
        done = (pages, topics, collection, hotTopics, noReplyTopics) ->
            response.render "#{tag.menu_template}/index",
                tag: tag
                topics: topics
                currentPage: page
                listTopicCount: limit
                inCollection: collection
                hotTopics: hotTopics
                noReplyTopics: noReplyTopics
                pages: pages
                extraStyle: style
        proxy = new EventProxy()
        events = ["pages", "topics"]#, "collection", "hotTopics", "noReplyTopics"]
        proxy.assign events, done

        # Topic 개수 구하기
        TopicTag.count { _tag: tag._id }, (error, count) ->
            # 페이지 구하기
            pages = Math.ceil(count / limit)
            proxy.emit "pages", pages

        # Topic 객체 추출
        TopicTag.find {
            _tag: tag._id
        }, null, {
            skip: (page - 1) * limit
            limit: limit
            sort: [
                ["create_at", "desc"]
            ]
        }, (error, topicTags) ->
            # 메뉴를 생성합니다.
            query = Topic.find
                _id:
                    $in: topicTags.map (item) -> item._topic
            query.sort { "create_at": "desc" }
            query.populate("_author", "login").populate("_tag", "name").exec proxy.done("topics")

exports.editTags = (request, response, next) ->
    Tag.getAllTags (error, tags) ->
        response.render "tags/editAll",
            tags: tags

exports.add = (request, response, next) ->
    # 요청 매개 변수를 추출합니다.
    name = request.param "name"
    name = initString name
    description = request.param "description"
    description = initString description
    menuTemplate = request.param "menu-template"
    menuTemplate = initString menuTemplate
    order = request.param "order"
    ancestors = request.param "ancestors"
    try
        ancestors = JSON.parse ancestors
    catch e
        ancestors = []


    # 유효성 검사
    unless name
        return response.render "notify/notify",
            error: "이름이 없엉"

    # 데이터베이스 요청을 수행합니다.
    Tag.getTagByName name, (error, tags) ->
        # 에러
        return next error if error
        if tags and tags.length > 0
            return response.render "notify/notify",
                error: "이미 있엉"

        tag = new Tag
            name: name
            menu_template: menuTemplate
            order: order
            description: description
            ancestors: ancestors
        tag.save (error) ->
            return next error if error
            response.redirect "/tags/edit"

exports.edit = (request, response, next) ->
    # 요청 매개 변수를 추출합니다.
    tagName = request.param "name"
    Tag.getTagByName tagName, (error, tag) ->
        # 에러 검사
        return next error if error
        unless tag
            return response.render "notify/notify",
                error: "존재하지 않는 태그입니다."

        Tag.getAllTags (error, tags) ->
            # 에러 검사
            return next error if error

            # 응답합니다.
            response.render "tags/edit",
                tag: tag
                tags: tags

exports.update = (request, response, next) ->
    id = request.param "id"
    Tag.getTagById id, (error, tag) ->
        return next error if error
        unless tag
            return response.render "notify/notify",
                error: "존재하지 않는 태그입니다."

        # 요청 매개 변수를 추출합니다.
        name = request.param "name"
        name = initString name
        order = request.param "order"
        menuTemplate = request.param "menu-template"
        menuTemplate = initString menuTemplate
        description = request.param "description"
        description = initString description
        ancestors = request.param "ancestors"
        try
            ancestors = JSON.parse ancestors
        catch e
            ancestors = []

        unless name
            return response.send "notify/notify",
                error: "이름이 이상해요"

        tag.name = name
        tag.order = order
        tag.menu_template = menuTemplate
        tag.description = description
        tag.ancestors = ancestors
        
        tag.save (error) ->
            return next error if error
            response.redirect "/tags/edit"
            log tag

exports.del = (request, response, next) ->
    # 요청 매개 변수를 추출합니다.
    tagName = request.param "name"
    Tag.getTagByName tagName, (error, tag) ->
        # 에러 검사
        return next error if error
        unless tag
            return response.render "notify/notify",
                error: "존재하지 않는 태그입니다."

    # 프록시를 생성합니다.
    proxy = new EventProxy()
    done = () ->
        tag.remove (error) ->
            return next error if error
            response.redirect "/"
    proxy.assign "topicTagRemoved", "tagCollectRemoved", done
    proxy.fail next

    TopicTag.removeByTagId tag._id, proxy.done("topicTagRemoved")
    TagCollect.removeAllByTagId tag._id, proxy.done("tagCollectRemoved")

exports.collect = (request, response, next) ->
exports.decollect = (request, response, next) ->