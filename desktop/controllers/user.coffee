# 모듈을 추출합니다.
validator = require "validator"
EventProxy = require "eventproxy"
moment = require "moment"
crypto = require "crypto"

# 함수를 추출합니다.
santitize = validator.santitize
check = validator.check

# 모델을 추출합니다.
User = models.User
Tag = models.Tag
Topic = models.Topic
Reply = models.Reply
Relation = models.Relation
TopicCollect = models.TopicCollect
TagCollect = models.TagCollect

# 모듈을 생성합니다.
exports.index = (request, response, next) ->
exports.showStars = (request, response, next) ->
exports.showSetting = (request, response, next) ->
exports.setting = (request, response, next) ->
exports.follow = (request, response, next) ->
exports.unFollow = (request, response, next) ->
exports.toggleStar = (request, response, next) ->
exports.getCollectTags = (request, response, next) ->
exports.getCollectTopics = (request, response, next) ->
exports.getFollowings = (request, response, next) ->
exports.getFollowers = (request, response, next) ->
exports.top100 = (request, response, next) ->
exports.listTopics = (request, response, next) ->
exports.listReplies = (request, response, next) ->