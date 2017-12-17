//
//  Caption.swift
//  insta-search
//
//  Created by Blaine Rothrock on 12/17/17.
//  Copyright © 2017 Blaine Rothrock. All rights reserved.
//

import Foundation

struct Caption: Codable {
    
    var createdTime:String
    var text:String
    var from:[String:String]
    var id:String
    
    enum CodingKeys: String, CodingKey {
        case createdTime = "created_time"
        case text
        case from
        case id
    }
}
