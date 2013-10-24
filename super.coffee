# 모듈을 추출합니다.
express = require "express"
mkdirp = require "mkdirp"

# 전역 변수
global.log = console.log
global.config = require "./config"
global.models = require "./models"
global.proxy = require "./proxy"
global.auth = require "./plugins/auth"
global.helper = require "./plugins/helper"


# 업로드와 언어 설정
mkdirp.sync config.uploadDir

# 서버를 생성합니다.
app = express()

# 모듈 설정
# mobile = require "./mobile/app.js"
# upload = require "./upload/app.js"
desktop = require "./desktop/app.js"

# 서버 설정
# app.use express.vhost("m.*", mobile.active(52273))
# app.use express.vhost("upload.*", upload.active(52274))
app.use express.vhost("*", desktop.active(52273))

# 서버를 실행합니다.
app.listen 3000, () ->
    log "super host is running on a port 52273"