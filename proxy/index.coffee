# 모듈을 추출합니다.
mongoose = require "mongoose"

# 모듈을 생성합니다.
###
exports.User = require "./user"
exports.Topic = require "./topic"
exports.Tag = require "./tag" 
exports.TopicTag = require "./topicTag"  
exports.TagCollect = require "./tagCollect" 
exports.Reply = require "./reply" 
exports.TopicCollect = require "./topicCollect" 
exports.Relation = mongoose.model "./relation" 
exports.Message = mongoose.model "./message" 
###