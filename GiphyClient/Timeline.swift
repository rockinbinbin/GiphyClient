//
//  Timeline.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import Foundation
import RealmSwift

class Post: Object {
    dynamic var date = NSDate()
    dynamic var text : String?
    dynamic var gif : Gif?
}

class Timeline: Object {
    var posts = List<Post>()
}
