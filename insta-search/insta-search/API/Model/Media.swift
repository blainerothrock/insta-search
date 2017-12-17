//
//  Media.swift
//  insta-search
//
//  Created by Blaine Rothrock on 12/17/17.
//  Copyright © 2017 Blaine Rothrock. All rights reserved.
//

import Foundation

struct MediaResponse: Codable {
    var data:[Media]
}

struct Media: Codable {
    
    var type:String
//    var usersInPhoto:[String]
    var filter:String
    var tags:[String]
    var comments:[String:Int]
    var caption:Caption
    var likes:[String:Int]
    var link:String
//    var user:User
    var createdTime:String
    var images: ImageMeta?
    var videos: VideoMeta?
    var id:String
//    var location: String
    
    enum CodingKeys: String, CodingKey {
        case type
//        case usersInPhoto = "users_in_photo"
        case filter
        case tags
        case comments
        case caption
        case likes
        case link
//        case user
        case createdTime = "created_time"
        case images
        case videos
        case id
//        case location
    }
    
}
