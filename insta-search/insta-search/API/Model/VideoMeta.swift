//
//  VideoMeta.swift
//  insta-search
//
//  Created by Blaine Rothrock on 12/17/17.
//  Copyright © 2017 Blaine Rothrock. All rights reserved.
//

import Foundation

protocol MediaMeta {
    var lowRes:MediaMetaDetail? { get set }
    var standardRes:MediaMetaDetail? { get set }
}

struct VideoMeta: Codable, MediaMeta {

    var lowRes:MediaMetaDetail?
    var standardRes:MediaMetaDetail?
    
    enum CodingKeys: String, CodingKey {
        case lowRes = "low_resolution"
        case standardRes = "standard_resolution"
    }
}
