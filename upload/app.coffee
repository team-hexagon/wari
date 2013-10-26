# ����� �����մϴ�.
express = require "express"
http = require "http"
path = require "path"
mkdirp = require "mkdirp"
moment = require "moment"
everyauth = require "everyauth"
everyauth.debug = true

# ���ε� ���� ����
config.uploadDir = config.uploadDir or path.join(__dirname, "public", "user_data", "images")
mkdirp.sync(config.uploadDir)

# ��� ����
moment.lang "ja"

# ������ �����մϴ�.
app = express()

# ������ �����մϴ�.
require("../plugins/auth")(app)

# ������ �����մϴ�.
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

# ���Ʈ�մϴ�.
require("./routes")(app)

# ������ �����մϴ�.
exports.active = (port) ->
    http.createServer(app).listen port, () ->
        console.log "Express server listening on port " + app.get("port")
    return app