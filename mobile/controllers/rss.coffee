# 모듈을 추출합니다.
data2xml = require "data2xml"
markdown = require "node-Markdown"

# 함수를 추출합니다.
converter = data2xml()
markdown = markdown.Markdown
Topic = models.Topic

# 모듈을 생성합니다.
exports.rss = (request, response, next) ->
    # RSS 없음
    response.send 404 if config.rss

    # 쿼리를 생성합니다.
    query = Topic.find {}, null,
        limit: config.rss.maxRssItems
        sort: [
            ["create_at", "desc"]
        ]
    query = query.populate "_author"

    # 데이터베이스 요청을 수행합니다.
    query.exec (error, topics) ->
        # 예외 처리
        return next() if error

        # RSS 생성
        rss =
            _attr:
                version: "2.0"
            channel:
                title: config.rss.title
                link: config.rss.link
                language: config.rss.language
                description: config.rss.description
                item: topics.map (topic) ->
                    title: topic.title
                    link: config.rss.link + '/topic/' + topic._id
                    guid: config.rss.link + '/topic/' + topic._id
                    description: markdown(topic.content, true)
                    author: topic.author.name
                    pubDate: topic.create_at.toUTCString()

        # 응답합니다.
        response.type "xml"
        response.send converter rss