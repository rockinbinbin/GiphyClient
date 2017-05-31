//
//  ExpandedGifViewController.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import SwiftyJSON
import FLAnimatedImage
import CHTCollectionViewWaterfallLayout

// Use this view to type Gif caption and post to story

class ExpandedGifViewController: UIViewController {

    public init(gif: Gif) {
        self.gif = gif
        super.init(nibName: nil, bundle: nil)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var gif : Gif

    private lazy var gifView: FLAnimatedImageView = {
        let gifView = FLAnimatedImageView()
        gifView.backgroundColor = UIColor.darkGray
        gifView.contentMode = .scaleAspectFill
        self.view.addSubview(gifView)
        return gifView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "SunriseGradient")!)
        self.navigationController?.navigationBar.styleNavBar()

        gifView.autoSetDimension(.width, toSize: self.view.frame.size.width)
        gifView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        gifView.autoAlignAxis(toSuperviewAxis: .vertical)
        self.loadGif(gif: self.gif, gifSize: .original)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadGif(gif: Gif, gifSize: GifSize) {
        guard let url = URL(string: gif.meta_data[gifSize.rawValue]["url"].string!) else {
            return
        }
        if url.absoluteString == "" { return }
        self.gif = gif

        DispatchQueue.global(qos: .background).async {
            gif.animated_image = FLAnimatedImage(animatedGIFData: NSData(contentsOf: url)! as Data)
            DispatchQueue.main.async {
                self.gifView.alpha = 0
                self.gifView.animatedImage = gif.animated_image
                UIView.animate(withDuration: 0.5, animations: {
                    self.gifView.alpha = 1
                })
            }
        }
    }
}
