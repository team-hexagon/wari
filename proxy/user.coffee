 # 모듈을 추출합니다.
mongoose = require "mongoose"
Schema = mongoose.Schema
config = require "../config"
log = console.log

# 스키마를 생성합니다.
UserSchema = new Schema
    name:
        type: String
        index: true
    login:
        type: String
        unique: true
    password:
        type: String
    email:
        type: String
        unique: true
    url: 
        type: String
    profile_image_url:
        type: String
    location:
        type: String
    signature:
        type: String
    profile:
        type: String
    avatar:
        type: String
    score: 
        type: Number
        default: 0
    topic_count:
        type: Number
        default: 0
    reply_count:
        type: Number
        default: 0
    follower_count:
        type: Number
        default: 0 
    following_count:
        type: Number
        default: 0 
    collect_tag_count:
        type: Number
        default: 0 
    collect_topic_count:
        type: Number
        default: 0 
    create_at:
        type: Date
        default: Date.now 
    update_at:
        type: Date
        default: Date.now 
    is_star:
        type: Boolean 
    level:
        type: String 
    active:
        type: Boolean
        default: true 
    receive_reply_mail:
        type: Boolean
        default: false 
    receive_at_mail:
        type: Boolean
        default: false 
    from_wp:
        type: Boolean 
    retrieve_time:
        type: Number 
    retrieve_key:
        type: String

# 가상 경로를 생성합니다.
UserSchema.virtual("avatar_url").get () ->
    url = "#{this.profile_image_url or this.avatar or config.site_static_host}/public/images/user_icon&48.png";
    url.replace "http://www.gravatar.com/", "http://gravatar.qiniudn.com/"

# 모델을 생성합니다.
User = mongoose.model "User", UserSchema
User.getUsersByNames = (names, callback) ->
    return callback null, [] if names.length is 0
    User.find
        name:
            $in: names
    , callback

User.getUserByLogin = (login, callback) ->
    User.findOne
        login: login
    , callback

User.getUserById = (id, callback) ->
    User.findOne
        _id: id
    , callback

User.getUserByName = (name, callback) ->
    User.findOne
        name: name
    , callback

User.getUserByMail = (email, callback) ->
    User.findOne
        email: email
    , callback

User.getUsersByIds = (ids, callback) ->
    User.find
        _id:
            $in: ids
    , callback

User.getUsersByQuery = (query, option, callback) ->
    User.find query, [], option, callback

User.getUserByQuery = (query, option, callback) ->
    User.findOne query, [], option, callback

# 모듈을 생성합니다.
module.exports = User