upload = require "./controllers/upload"
module.exports = (app) ->
    # 업로드
    app.post "/images", upload.uploadImage