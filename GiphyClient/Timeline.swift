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
    dynamic var gif_data : NSData?
}

class Timeline: Object {
    static let sharedInstance = Timeline()
    var posts = List<Post>()

    func retrievePostsByDay(day: NSDate) -> [Post] {
        let orderedPosts : NSMutableArray = []
        for post in posts {
            if NSCalendar.current.isDateInToday(post.date as Date) {
                orderedPosts.add(post)
            }
        }
        let sortedPosts = orderedPosts.sorted(by: { ($0 as AnyObject).date.compare(($1 as AnyObject).date! as Date) == ComparisonResult.orderedDescending })
        return sortedPosts as! [Post]
    }
}
