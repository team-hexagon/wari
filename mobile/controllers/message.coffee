# 모듈을 추출합니다.
EventProxy = require "eventproxy"

# 모델을 추출합니다.
Message = models.Message

# 모듈을 생성합니다.
exports.index = (request, response, next) ->
    response.redirect "home" unless request.user
    message_ids = []
    user_id = request.user._id

exports.markRead = (request, response, next) ->
exports.markAllRead = (request, response, next) ->