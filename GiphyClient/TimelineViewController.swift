//
//  Timeline.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import FLAnimatedImage
import SwiftyJSON
import RealmSwift

class TimelineViewController: UIViewController {

    var posts : NSArray = []

    var currentIndex = 0

    private lazy var gifView: FLAnimatedImageView = {
        let gifView = FLAnimatedImageView()
        gifView.backgroundColor = UIColor.darkGray
        self.view.addSubview(gifView)
        return gifView
    }()

    fileprivate lazy var circleButton: UIButton = {
        let circleButton = UIButton(type: .roundedRect)
        circleButton.layer.cornerRadius = 20
        circleButton.layer.borderColor = UIColor.EazeBlue().cgColor
        circleButton.layer.borderWidth = 2
        circleButton.backgroundColor = UIColor.EazeBlue()
        circleButton.addTarget(self, action: #selector(TimelineViewController.nextPressed), for: .touchUpInside)
        self.view.addSubview(circleButton)
        return circleButton
    }()

    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: 4)
        self.gifView.addSubview(label)
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "UnderwaterGradient")!)
        gifView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        gifView.autoAlignAxis(toSuperviewAxis: .vertical)
        gifView.autoSetDimension(.width, toSize: self.view.frame.size.width)

        label.autoPinEdge(toSuperviewEdge: .bottom)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.sizeToFit()

        circleButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 60)
        circleButton.autoAlignAxis(toSuperviewAxis: .vertical)
        circleButton.autoSetDimension(.height, toSize: 40)
        circleButton.autoSetDimension(.width, toSize: 40)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleNavBar()
        self.posts = Timeline.sharedInstance.retrievePostsByDay(day: NSDate()) as NSArray
        loadPost(gifSize: .original)
        currentIndex = 0
    }

    func styleNavBar() {
        self.navigationController?.navigationBar.styleNavBar()
        let titleLabel = UILabel()
        let attributes: NSDictionary = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: 5.0),
            NSForegroundColorAttributeName: UIColor.EazeBlue(),
            NSKernAttributeName: CGFloat(5)
        ]
        let attributedTitle = NSAttributedString(string: "M👀D", attributes: attributes as? [String : AnyObject])
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadPost(gifSize: GifSize) {
        guard posts.count != 0 else { return }
        let currentPost : Post = posts[self.currentIndex] as! Post
        let data : NSData = currentPost.gif_data!
        let json = JSON(data: data as Data)

        guard let url = URL(string: json[gifSize.rawValue]["url"].string!) else { return }
        if url.absoluteString == "" { return }

        DispatchQueue.global(qos: .background).async {
            let animated_image = FLAnimatedImage(animatedGIFData: NSData(contentsOf: url)! as Data)
            DispatchQueue.main.async {
                self.gifView.alpha = 0
                self.gifView.animatedImage = animated_image
                UIView.animate(withDuration: 0.5, animations: {
                    self.gifView.alpha = 1
                })
            }
        }
    }

    func nextPressed() {
        if currentIndex != (posts.count - 1) {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        loadPost(gifSize: .original)
    }
}
