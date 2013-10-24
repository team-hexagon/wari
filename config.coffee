path = require("path")

module.exports = 
    debug: true
    name: "Waseda Wari Project"
    description: "rintiantta"
    version: "0.0.1"
    siteHeaders: []
    host: "localhost.wari.com"
    siteNavs: [
        # [path, title]
        ["/about", "about"]
    ]
    siteStaticHost: ""
    siteEnableSearchPreview: false
    siteGoogleSearchDomain: "wari.co.jp"

    publicPath: path.join(__dirname, "public")
    uploadDir: path.join(__dirname, "public", "upload")

    db: "mongodb://127.0.0.1/wari"
    sessionSecret: "rintianttaaktrasaniattta"
    port: 3000

    oauth:
        facebook:
            appId: "413784885326087"
            appSecret: "6153e88f10e3c998da0465a52892376b"

    listTopicCount: 15
    postInterval: 10000

    rss:
        title: "Wari: wari"
        link: "http://wari.co.jp"
        language: "ja-jp"
        description: "wari"
        maxRssItems: 50

    siteLinks: [{
        text: "waseda"
        url: "http://www.waseda.jp/"
    }, {
        text: "rint"
        url: "http://www.waseda.jp"
    }]

    sideAds: [{
        url: ""
        image: ""
    }, {
        url: ""
        image: ""
    }]

    mailOpts:
        host: "smtp.wari.co.jp"
        port: 25
        auth: {
            user: "admin@wari.com"
            password: "admin"
        }

    admins:
        admin: true