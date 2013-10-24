# 모듈을 추출합니다.
mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

# 스키마를 생성합니다.
ReplySchema = new Schema
    content:
        type: String
    _topic:
        type: ObjectId
        index: true
    _author:
        type: ObjectId
        ref: "User"
    _reply:
        type: ObjectId
        ref: "Reply"
    create_at:
        type: Date
        default: Date.now
    update_at:
        type: Date
        default: Date.now
    content_is_html:
        type: Boolean

# 모델을 생성합니다.
Reply = mongoose.model "Reply", ReplySchema
Reply.getReplyById = (id, callback) ->
    Reply.findOne({
        _id: id
    }).populate('_author').populate('_reply').exec(callback)

Reply.getRepliesByTopicId = (id, callback) ->
    Reply.find({ 
        _topic: id 
    }, [], {
        sort: [
            ["created_at", "asc"]
        ]
    }).populate("_author").exec(callback)

exports.getRepliesByAuthorId = (id, callback) ->
    Reply.find { _author: id }, callback

# 모듈을 생성합니다.
module.exports = Reply