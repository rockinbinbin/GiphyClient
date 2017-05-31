//
//  Model.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import FLAnimatedImage


let mediaHeight : CGFloat = 300.00
let trendingURL = "http://api.giphy.com/v1/gifs/trending?"
let searchURL = "http://api.giphy.com/v1/gifs/search?"
let APIKey = "&api_key=dc6zaTOxFJmzC"

protocol DataDelegate {
    func passJSON(json: JSON, newSearch: Bool, isSearching: Bool)
}

protocol ViewControllerDelegate {
    func cacheGif(gif: Gif, row: Int)
    func pushGifView(gif: Gif)
}

public class Model {
    static let sharedInstance = Model()
    var dataDelegate: DataDelegate? = nil

    var trendingCache: NSCache<AnyObject, Gif> = NSCache()
    var searchCache: NSCache<AnyObject, Gif> = NSCache()

    var trendingJSON: JSON?

    var searchJSON: JSON?
    var isSearching = false
    var searchParameters: [String: AnyObject]?

    func getPosts(urlStr: String, newSearch: Bool, isSearching: Bool) {
        var url : URL?
        if isSearching {
            self.searchJSON = nil
            url = URL(string: urlStr)
        }
        else {
            url = URL(string: (trendingURL + "&limit=\(500)\(APIKey)"))
        }

        guard url != nil else {
            return
        }

        let request = NSMutableURLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            guard let data = data else {
                print("error retrieving posts")
                return
            }
            if isSearching {
                self.searchJSON = JSON(data: data)
            }
            else {
                self.trendingJSON = JSON(data: data)
            }
            self.dataDelegate?.passJSON(json: JSON(data: data), newSearch: newSearch, isSearching: isSearching)
        }).resume()
        return
    }

    // TODO: consolidate these methods
    func getTrendingGifs() {
        isSearching = false
        getPosts(urlStr: (trendingURL + "\(APIKey)"), newSearch: false, isSearching: false)
    }

    func getSearchGifs(parameters: [String: AnyObject]) {
        self.searchJSON = nil
        isSearching = true
        self.searchParameters = parameters
        let parameterString = parameters.stringFromHttpParameters()
        getPosts(urlStr: ("\(searchURL)\(parameterString)\(APIKey)"), newSearch: true, isSearching: true)
    }

    func getNumGifs() -> Int {
        let json = isSearching ? searchJSON : trendingJSON
        guard let response = json?["pagination"]["count"].numberValue else {
            return 100
        }
        return Int(response)
    }

//    func getGifSize(index: Int, gifSize: GifSize) -> CGSize {
//        var json: JSON? = isSearching ? searchJSON : trendingJSON
//        guard json != nil else {
//            return CGSize(width: 50, height: 50)
//        }
//        let width = json?["data"][index]["images"][gifSize.rawValue]["width"].string
//        let height = json?["data"][index]["images"][gifSize.rawValue]["height"].string
//
//        if width == nil || height == nil {
//            return CGSize(width: 50, height: 50)
//        }
//        return CGSize(width: Int(width!)!, height: Int(height!)!)
//    }
}
