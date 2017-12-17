//
//  User.swift
//  insta-search
//
//  Created by Blaine Rothrock on 12/17/17.
//  Copyright © 2017 Blaine Rothrock. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var id:String
    var username:String
    var fullName:String
    var profileImage:String
    var bio:String
    var website:String
    var counts: [String:Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName = "full_name"
        case profileImage = "profile_picture"
        case bio
        case website
        case counts
    }
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DataKeys.self)
        let userValues = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.id = try userValues.decode(String.self, forKey: .id)
        self.username = try userValues.decode(String.self, forKey: .username)
        self.fullName = try userValues.decode(String.self, forKey: .fullName)
        self.profileImage = try userValues.decode(String.self, forKey: .profileImage)
        self.bio = try userValues.decode(String.self, forKey: .bio)
        self.website = try userValues.decode(String.self, forKey: .website)
        self.counts = try userValues.decode([String:Int].self, forKey: .counts)
    }
    
}
