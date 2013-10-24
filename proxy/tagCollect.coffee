mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

TopicCollectSchema = new Schema
	_user:
		type: ObjectId
		required: true
		ref: "User"
	_topic:
		type: ObjectId
		required: true
		ref: "Topic"
	create_at:
		type: Date
		default: Date.now

# 모델을 생성합니다.
TopicCollect = mongoose.model "TopicCollect", TopicCollectSchema
TopicCollect.getTopicCollect = (userId, topicId, callback) ->
	TopicCollect.findOne
		_user: userId
		_topic: topicId
	, callback

TopicCollect.getTopicCollectByUserId = (userId, callback) ->
	TopicCollect.find
		_user: userId
	, callback

# 모듈을 생성합니다.
module.exports = TopicCollect