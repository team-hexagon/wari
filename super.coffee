# ����� �����մϴ�.
express = require "express"
mkdirp = require "mkdirp"

# ���� ����
global.log = console.log
global.config = require "./config"
global.models = require "./models"
global.proxy = require "./proxy"
global.auth = require "./plugins/auth"
global.helper = require "./plugins/helper"


# ���ε�� ��� ����
mkdirp.sync config.uploadDir

# ������ �����մϴ�.
app = express()

# ��� ����
# mobile = require "./mobile/app.js"
# upload = require "./upload/app.js"
desktop = require "./desktop/app.js"

# ���� ����
# app.use express.vhost("m.*", mobile.active(52273))
# app.use express.vhost("upload.*", upload.active(52274))
app.use express.vhost("*", desktop.active(52273))

# ������ �����մϴ�.
app.listen 3000, () ->
    log "super host is running on a port 52273"