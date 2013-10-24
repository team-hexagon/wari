# 모듈을 추출합니다.
mongoose = require "mongoose"
config = require "../config"
log = console.log

# 데이터베이스 연결을 수행합니다.
mongoose.connect config.db, (error) ->
    if error
        console.error "connect to #{config.db}"
        process.exit 1


# 모듈을 생성합니다.
exports.User = require "./user"
exports.Topic = require "./topic"
exports.Tag = require "./tag" 
exports.TopicTag = require "./topicTag"  
exports.TagCollect = require "./tagCollect" 
exports.Reply = require "./reply" 
###
exports.TopicCollect = require "./topicCollect" 
exports.Relation = mongoose.model "./relation" 
exports.Message = mongoose.model "./message" 
###