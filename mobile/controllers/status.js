(function() {

  exports.status = function(request, response) {
    return response.send({
      status: "success",
      current: Date.now()
    });
  };

}).call(this);
