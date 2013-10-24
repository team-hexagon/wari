exports.index = (req, res, next) ->
    res.render "campus/index"
exports.notice = (req, res, next) ->
    res.render "campus/notice"
exports.schedule = (req, res, next) ->
    res.render "campus/schedule"
exports.news = (req, res, next) ->
    res.render "campus/news"
exports.restaurant = (req, res, next) ->
    res.render "campus/restaurant"
exports.about = (req, res, next) ->
    res.render "campus/about"

