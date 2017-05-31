//
//  Gif.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import Foundation
import FLAnimatedImage
import SwiftyJSON

enum GifSize: String {
    case fixed_height = "fixed_height"
    case fixed_height_still = "fixed_height_still"
    case fixed_height_downsampled = "fixed_height_downsampled"
    case fixed_width = "fixed_width"
    case fixed_width_still = "fixed_width_still"
    case fixed_width_downsampled = "fixed_width_downsampled"
    case fixed_height_small_still = "fixed_height_small_still"
    case fixed_width_small = "fixed_width_small"
    case downsized = "downsized"
    case downsized_still = "downsized_still"
    case downsized_large = "downsized_large"
    case original = "original"
}

class Gif: NSObject {
    let meta_data : JSON
    var animated_image : FLAnimatedImage?

    init(meta_data: JSON) {
        self.meta_data = meta_data
    }

    func getSize(gifSize: GifSize) -> CGSize {
        let width = meta_data["images"][gifSize.rawValue]["width"].string
        let height = meta_data["images"][gifSize.rawValue]["height"].string
        if width == nil || height == nil {
            return CGSize(width: 50, height: 50)
        }
        return CGSize(width: Int(width!)!, height: Int(height!)!)
    }
}
