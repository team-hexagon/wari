# 모듈을 추출합니다.
express = require "express"
http = require "http"
path = require "path"
mkdirp = require "mkdirp"
moment = require "moment"
everyauth = require "everyauth"
everyauth.debug = true

# 업로드 관련 설정
config.uploadDir = config.uploadDir or path.join(__dirname, "public", "user_data", "images")
mkdirp.sync(config.uploadDir)

# 언어 설정
moment.lang "ja"

# 서버를 생성합니다.
app = express()

# 인증을 구현합니다.
require("../plugins/auth")(app)

# 서버를 설정합니다.
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
# app.set "view cache", true
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser
    uploadDir: config.uploadDir
app.use express.cookieParser()
app.use express.session
    secret: config.sessionSecret
app.use everyauth.middleware()
app.use express.static(config.publicPath)
app.use (request, response, next) ->
    response.locals 
        path: request.path
    next()
app.use app.router
app.use express.errorHandler() if "development" is app.get("env")
app.locals
    config: config
    moment: moment

# 라우트합니다.
require("./routes")(app)

# 서버를 실행합니다.
exports.active = (port) ->
    http.createServer(app).listen port, () ->
        console.log "Express server listening on port " + app.get("port")
    return app