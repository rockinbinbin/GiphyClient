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

    var posts : List<Post>?
    var currentIndex = 0

    private lazy var gifView: FLAnimatedImageView = {
        let gifView = FLAnimatedImageView()
        gifView.backgroundColor = UIColor.darkGray
        return gifView
    }()

    fileprivate lazy var circleButton: UIButton = {
        let circleButton = UIButton(type: .roundedRect)
        circleButton.layer.cornerRadius = 30
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
        label.font = UIFont.systemFont(ofSize: 32, weight: 4)
        self.view.addSubview(label)
        return label
    }()

    fileprivate lazy var timelabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: 2)
        label.text = ""
        self.view.addSubview(label)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "UnderwaterGradient")!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleNavBar()
        currentIndex = 0

        timelabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        timelabel.autoAlignAxis(toSuperviewAxis: .vertical)
        timelabel.sizeToFit()

        self.view.addSubview(gifView)
        gifView.autoPinEdge(.top, to: .bottom, of: timelabel, withOffset: 5)
        gifView.autoAlignAxis(toSuperviewAxis: .vertical)
        gifView.autoSetDimension(.width, toSize: self.view.frame.size.width)
        gifView.autoSetDimension(.height, toSize: 300)

        //label.autoPinEdge(toSuperviewEdge: .bottom)
        label.autoPinEdge(.top, to: .bottom, of: gifView, withOffset: 5)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoSetDimension(.width, toSize: self.view.frame.size.width - 10)
        label.sizeToFit()

        circleButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 60)
        circleButton.autoAlignAxis(toSuperviewAxis: .vertical)
        circleButton.autoSetDimension(.height, toSize: 60)
        circleButton.autoSetDimension(.width, toSize: 60)
        getPostsInRealm(index: 0)
    }

    func getPostsInRealm(index: Int) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                let realm = try! Realm()
                let posts = Timeline.sharedInstance.retrievePostsByDay(day: NSDate(), posts: List(realm.objects(Post.self)))
                self.posts = posts

                let currentPost : Post = posts[index]
                let postRef = ThreadSafeReference(to: currentPost)

                let data : NSData = currentPost.gif_data!
                let json = JSON(data: data as Data)

                guard let url = URL(string: json["original"]["url"].string!) else { return }
                if url.absoluteString == "" { return }

                let animated_image = FLAnimatedImage(animatedGIFData: NSData(contentsOf: url)! as Data)

                DispatchQueue.main.async {
                    self.gifView.alpha = 0
                    self.gifView.animatedImage = animated_image
                    UIView.animate(withDuration: 0.5, animations: {
                        self.gifView.alpha = 1
                        self.gifView.backgroundColor = UIColor.red
                    })

                    let realm = try! Realm()
                    guard let this_post = realm.resolve(postRef) else {
                        return
                    }

                    self.label.text = this_post.text
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: this_post.date as Date)
                    let minutes = calendar.component(.minute, from: this_post.date as Date)
                    if hour > 12 {
                        self.timelabel.text = "Today @ \(hour - 12):\(minutes) pm"
                    } else {
                        self.timelabel.text = "Today @ \(hour):\(minutes) am"
                    }
                }
            }
        }
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

    func nextPressed() {
        if currentIndex != ((posts?.count)! - 1) {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        getPostsInRealm(index: currentIndex)
    }
}
