# 모듈을 추출합니다.
config = require "../config" 
everyauth = require "everyauth"
crypto = require "crypto"
validator = require "validator"
models = require "../models"

# 함수를 선언합니다.
log = console.log
sanitize = validator.sanitize
check = validator.check
User = models.User
convertHash = (input) ->
    shasum = crypto.createHash "sha1"
    shasum.update input
    return shasum.digest "hex"

# 모듈을 생성합니다.
exports = module.exports = (app) ->
    # 페이스북 로그인 구현
    everyauth.facebook
        .entryPath("/auth/facebook")
        .appId(config.oauth.facebook.appId)
        .appSecret(config.oauth.facebook.appSecret)
        .handleAuthCallbackError((request, response) ->
            log "error"
        ).findOrCreateUser((session, accessToken, accessTokenExtra, fbUserMetadata) ->
            promise = @Promise null
            User.getUserByLogin fbUserMetadata.id, (error, user) ->
                # 오류
                return promise.fulfill [error] if error
                if user
                    # 사용자가 존재하는 경우
                    promise.fulfill user
                else
                    # 사용자가 존재하지 않는 경우
                    User.insert
                        name: fbUserMetadata.username
                        login: fbUserMetadata.id
                        password: "facebook"
                    , (error, user) ->
                        promise.fulfill user
            return promise
        ).redirectPath("/")

    # 기본 로그인 구현
    auth = everyauth.password.loginWith "login"
    everyauth.everymodule.userPkey "_id"
    everyauth.everymodule.findUserById (id, callback) ->
        User.findById id, callback

    # 로그아웃 구현
    everyauth.everymodule.logoutPath "/logout"
    everyauth.everymodule.logoutRedirectPath "/"

    # 가입 구현
    auth.registerView "auth/register"
    auth.getRegisterPath "/register"
    auth.postRegisterPath "/register"
    auth.extractExtraRegistrationParams (request) ->
        passwordConfirm: request.param "password-confirm"
        email: request.param "email"
    auth.validateRegistration (userAttribute, errors) ->
        # Promise 객체 생성
        promise = @Promise null
        log userAttribute

        # 변수 수정
        name = sanitize(userAttribute.login).xss()
        login = name.toLowerCase()
        password = sanitize(userAttribute.password).trim()
        password = sanitize(password).xss()
        passwordConfirm = sanitize(userAttribute.passwordConfirm).trim()
        passwordConfirm = sanitize(passwordConfirm).xss()
        email = sanitize(userAttribute.email.toLowerCase()).xss()

        # 오류 확인
        return [{
            error: "오류"
            login: login
        }] if name is "" and password is "" and passwordConfirm is ""
        
        return [{
            error: "오류"
            login: login
        }] if name.length < 5

        try
            check(name, "0-9, a-z, A-Z").isAlphanumeric()
        catch e
            return [{
                error: e.message
                name: name
            }]

        try
            check(email, "이메일 형식이 아닙니다.").isEmail()
        catch e
            return [{
                error: e.message
                email: email
            }]
        
        
        return [{
            error: "not match"
        }] unless userAttribute.passwordConfirm

        # 중복 확인
        User.findOne
            $or: [
                { login: login }
                { email: email }
            ]
        , (error, user) ->
            # 변수를 선언합니다.
            errors = []
            errors.push {error: "데이터베이스 오류 발생"} if error
            errors.push {error: "같은 이름의 사용자가 존재합니다."} if user

            # 종료
            if errors.length
                promise.fulfill errors 
            else
                promise.fulfill {}

        # 리턴합니다.
        return promise

    auth.registerUser (userAttribute) ->
        # Promise 객체 생성
        promise = @Promise null

        # 데이터베이스 요청을 수행합니다.
        user = new User
            name: userAttribute.name
            login: userAttribute.login.toLowerCase()
            password: convertHash userAttribute.password
        user.save (error, user) ->
            if error 
                promise.fulfill ["데이터베이스 오류가 발생했습니다."]
            else
                promise.fulfill user

        # 리턴합니다.
        return promise
    auth.registerSuccessRedirect "/"

    # 로그인
    auth.loginView "auth/login"
    auth.getLoginPath "/login"
    auth.postLoginPath "/login"
    auth.authenticate (login, password) ->
        # 변수를 선언합니다.
        errors = []
        promise = @Promise()

        # 데이터베이스 요청을 수행합니다.
        User.getUserByLogin login.toLowerCase(), (error, user) ->
            errors.push "데이터베이스 오류가 발생했습니다." if error
            errors.push "존재하지 않는 사용자 입니다." unless user
            errors.push "비밀번호가 일치하지 않습니다." if user and user.password isnt convertHash password
            return promise.fulfill errors if errors.length
            return promise.fulfill user

        # 리턴합니다.
        return promise
    auth.loginSuccessRedirect "/"
