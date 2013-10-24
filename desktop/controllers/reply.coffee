# 모듈을 추출합니다.
validator = require "validator"
EventProxy = require "eventproxy"

# 함수를 추출합니다.
santitize = validator.santitize
User = models.User
Topic = models.Topic
Reply = models.Reply

# 모듈을 생성합니다.
exports.add = (request, response, next) ->
exports.addReply2 = (request, response, next) ->
exports.del = (request, response, next) ->