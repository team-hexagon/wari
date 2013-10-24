# 모듈을 추출합니다.
config = require "../config"
POST_INTERVAL = config.postInterval
POST_INTERVAL = 0 unless POST_INTERVAL > 0
DISABLE_POST_INTERVAL = if POST_INTERVAL > 0 then false else true

# 모듈을 생성합니다.
exports.adminRequired = (request, response, next) ->
    unless request.session.user
        return response.render "notify/notify",
            error: "로그인을 해주세요."
    unless request.session.user.is_admin
        return response.render "notify/notify",
            error: "관리자가 아닙니다."
    next()

exports.userRequired = (request, response, next) ->
    return response.send 403 unless request.user
    next()

exports.signinRequired = (request, response, next) ->
    unless request.session.user
        return response.render "notify/notify",
            error: "로그인 해주세요."
    next()

exports.postInterval = (request, response) ->
    return next() if DISABLE_POST_INTERVAL
    if isNaN(request.session.lastPostTimestamp)
        request.session.lastPostTimestamp = Date.now()
        return next()
    if Date.now() - request.session.lastPostTimestamp < POST_INTERVAL
        ERROR_MSG = "Plaease refresh webpage."
        if request.accepts("json")
            response.send
                error: ERROR_MSG
        else
            response.render "notify/notify",
                error: ERROR_MSG
        return
    request.session.lastPostTimestamp = Date.now()
    next()

exports.activeAccount = (request, response, next) ->