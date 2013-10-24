# 모듈을 추출합니다.
mongoose = require "mongoose"
EventProxy = require "eventproxy"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
log = console.log

# 스키마를 정의합니다.
TopicSchema = new Schema
    title:
        type: String
        required: true
    content:
        type: String
        required: true
    _author:
        type: ObjectId
        ref: "User"
        required: true
    _tag:
        type: ObjectId
        ref: "Tag"
        required: true
    top:
        type: Boolean
        default: false
    reply_count:
        type: Number
        default: 0
    visit_count:
        type: Number
        default: 0
    collect_count:
        type: Number
        default: 0
    create_at:
        type: Date
        default: Date.now
    update_at:
        type: Date
        default: Date.now
    _last_reply:
        type: ObjectId
        ref: "Reply"
    last_reply_at:
        type: Date
        default: Date.now
    content_is_html:
        type: Boolean

# 모델을 생성합니다.
Topic = mongoose.model "Topic", TopicSchema
Topic.getTopicById = (id, calback) ->
    # topics 속성
    Topic.findOne
        _id: id
    .populate("_author")
    .populate("_last_reply")
    .exec (error, topic) ->
        # 오류 확인
        return callback error if error
        return callback null, null, [] unless topic

        # tags 속성
        TopicTag.find
            _topic: topic._id
        .populate "_topic"
        .exec (error, tags) ->
            callback null, topic, tags

Topic.updateLastReply = (topicId, replyId, callback) ->
    Topic.findOne
        _id: topicId
    , (error, topic) ->
        # 오류 확인
        return callback error if error

        # 업데이트
        topic._last_reply = replyId
        topic.last_reply_at = new Date()
        topic.reply_count += 1
        topic.save callback

Topic.reduceReply = (id, callback) ->
    Topic.findOne
        _id: id
    , (erorr, topic) ->
        # 오류 확인
        return callback error if error
        return callback new Error("No Reply") unless topic

        # 업데이트
        topic.reply_count -= 1
        topic.save callback

# 모듈을 생성합니다.
module.exports = Topic