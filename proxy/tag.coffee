mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

TagSchema = new Schema
    name:
        type: String
        required: true
    order:
        type: Number
        default: 1
    description:
        type: String
    menu_template:
        type: String
        required: true
    topic_count:
        type: Number
        default: 0    
    collect_count:
        type: Number
        default: 0
    create_at:
        type: Date
        default: Date.now
    ancestors:
        type: [{
            type: ObjectId
            ref: "Tag"
        }]
        default: []

# 모델을 생성합니다.
Tag = mongoose.model "Tag", TagSchema
Tag.getTagById = (id, callback) ->
    Tag.findById id, callback
    
Tag.getTagByName = (name, callback) ->
    Tag.findOne
        name: name
    , callback

Tag.getTagsByIds = (ids, callback) ->
    Tag.findOne
        _id:
            $in: ids
    , callback

Tag.getAllTags = (callback) ->
    Tag.find {}, null,
        sort: [
            ["order", "asc"]
        ]
    , callback

# 모듈을 생성합니다.
module.exports = Tag