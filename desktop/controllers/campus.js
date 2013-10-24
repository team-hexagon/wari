(function() {

  exports.index = function(req, res, next) {
    return res.render("campus/index");
  };

  exports.notice = function(req, res, next) {
    return res.render("campus/notice");
  };

  exports.schedule = function(req, res, next) {
    return res.render("campus/schedule");
  };

  exports.news = function(req, res, next) {
    return res.render("campus/news");
  };

  exports.restaurant = function(req, res, next) {
    return res.render("campus/restaurant");
  };

  exports.about = function(req, res, next) {
    return res.render("campus/about");
  };

}).call(this);
