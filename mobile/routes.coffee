site = require "./controllers/site"
status = require "./controllers/status"
campus = require "./controllers/campus"
rss = require "./controllers/rss"
topic = require "./controllers/topic"
reply = require "./controllers/reply"
upload = require "./controllers/upload"
user = require "./controllers/user"
message = require "./controllers/message"
tags = require "./controllers/tags"
###
sign = require("./controllers/sign")

tools = require("./controllers/tools")
###

log = console.log

module.exports = (app) ->
    # site 컨트롤러
    app.get "/", site.index

    # status 컨트롤러
    app.get "/status", status.status

    # campus 컨트롤러
    app.get "/campus", campus.index
    app.get "/campus/notice", campus.notice
    app.get "/campus/schedule", campus.schedule
    app.get "/campus/news", campus.news
    app.get "/campus/restaurant", campus.restaurant
    app.get "/campus/about", campus.about

    # rss 컨트롤러
    app.get "/rss", rss.rss

    # topics 컨트롤러
    # app.get "/topic/create", helper.signinRequired, helper.postInterval, topic.create
    app.get "/topic/create/:tagName", topic.create
    app.post "/topic/create/:tagName", topic.put
    # app.post "/topic/create", helper.signinRequired, topic.collect
    app.post "/topic/collect", helper.signinRequired, topic.collect
    app.post "/topic/decollect", helper.signinRequired, topic.decollect
    app.get "/topic/:tid", topic.index
    app.get "/topic/:tid/edit", topic.showEdit
    app.post "/topic/:tid/delete", topic.del

    # 댓글
    app.post "/:topicId/reply", helper.userRequired, helper.postInterval, reply.add
    app.post "/:topicId/reply2", helper.userRequired, helper.postInterval, reply.addReply2
    app.post "/reply/:replyId/delete", reply.del
    
    # 업로드
    app.post "/upload/image", upload.uploadImage

    # 사용자
    app.get "/user/:name", user.index
    app.get "/setting", user.showSetting
    app.post "/setting", user.setting
    app.get "/stars", user.showStars
    app.get "/users/top100", user.top100
    app.get "/user/:name/tags", user.getCollectTags
    app.get "/user/:name/collections", user.getCollectTopics
    app.get "/user/:name/follower", user.getFollowers
    app.get "/user/:name/following", user.getFollowings
    app.get "/user/:name/topics", user.listTopics
    app.get "/user/:name/replies", user.listReplies
    app.post "/user/follow", helper.userRequired, user.follow
    app.post "/user/unfollow", user.unFollow
    app.post "/user/setstar", user.toggleStar
    app.post "/user/cancelstar", user.toggleStar

    # 계정
    app.get "/activeAccount", helper.activeAccount

    # 메시지
    app.get "/my/messages", message.index
    app.post "/messages/markRead", message.markRead
    app.post "/messages/markAllRead", message.markAllRead

    

    # 태그
    app.get "/tags/edit", tags.editTags
    app.get "/tags/:name", tags.listTopic
    #app.get "/tags/:name/edit", helper.adminRequired, tags.edit
    app.get "/tags/:name/edit",tags.edit
    app.get "/tags/:name/delete", helper.adminRequired, tags.del
    app.post "/tags/add", tags.add
    #app.post "/tags/add", helper.adminRequired, tags.add
    app.post "/tags/:id", tags.update
    #app.post "/tags/:id", helper.adminRequired, tags.update
    app.post "/tags/collect", tags.collect
    app.post "/tags/decollect", helper.userRequired, tags.decollect