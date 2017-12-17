//
//  VideoMeta.swift
//  insta-search
//
//  Created by Blaine Rothrock on 12/17/17.
//  Copyright © 2017 Blaine Rothrock. All rights reserved.
//

import Foundation


struct VideoMeta: Codable {

    var lowRes:MediaMetaDetail
    var standardRes:MediaMetaDetail
    
    enum CodingKeys: String, CodingKey {
        case lowRes = "low_resolution"
        case standardRes = "standard_resolution"
    }
}
