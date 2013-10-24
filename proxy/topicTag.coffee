mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

TopicTagSchema = new Schema
	_topic:
		type: ObjectId
		required: true
		ref: "Topic"
	_tag:
		type: ObjectId
		required: true
		ref: "Tag"
	create_at:
		type: Date
		default: Date.now

# 모델을 생성합니다.
TopicTag = mongoose.model "TopicTag", TopicTagSchema
TopicTag.getTopicTagByTagId = (id, callback) ->
	TopicTag.find { tag_id:  id }, callback
TopicTag.getTopicTagByTopicId = (id, callback) ->
	TopicTag.find { topic_id: id }, callback
TopicTag.removeByTagId = (id, callback) ->
	TopicTag.remove { tag_id: id }, callback

# 모듈을 생성합니다.
module.exports = TopicTag