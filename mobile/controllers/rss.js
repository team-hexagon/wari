(function() {
  var Topic, converter, data2xml, markdown;

  data2xml = require("data2xml");

  markdown = require("node-Markdown");

  converter = data2xml();

  markdown = markdown.Markdown;

  Topic = models.Topic;

  exports.rss = function(request, response, next) {
    var query;
    if (config.rss) {
      response.send(404);
    }
    query = Topic.find({}, null, {
      limit: config.rss.maxRssItems,
      sort: [["create_at", "desc"]]
    });
    query = query.populate("_author");
    return query.exec(function(error, topics) {
      var rss;
      if (error) {
        return next();
      }
      rss = {
        _attr: {
          version: "2.0"
        },
        channel: {
          title: config.rss.title,
          link: config.rss.link,
          language: config.rss.language,
          description: config.rss.description,
          item: topics.map(function(topic) {
            return {
              title: topic.title,
              link: config.rss.link + '/topic/' + topic._id,
              guid: config.rss.link + '/topic/' + topic._id,
              description: markdown(topic.content, true),
              author: topic.author.name,
              pubDate: topic.create_at.toUTCString()
            };
          })
        }
      };
      response.type("xml");
      return response.send(converter(rss));
    });
  };

}).call(this);
