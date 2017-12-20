//
//  ImageMeta.swift
//  insta-search
//
//  Created by Blaine Rothrock on 12/17/17.
//  Copyright © 2017 Blaine Rothrock. All rights reserved.
//

import Foundation

struct ImageMeta: Codable {
    
    var standardRes: MediaMetaDetail?
    var lowRes: MediaMetaDetail?
    var thumbnail: MediaMetaDetail?
    
    enum CodingKeys: String, CodingKey {
        case standardRes = "standard_resolution"
        case lowRes = "low_resolution"
        case thumbnail
    }
}
