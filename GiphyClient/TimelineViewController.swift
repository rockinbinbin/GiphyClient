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

    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: self.view.frame)
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        return scrollView
    }()

    private lazy var gifView: FLAnimatedImageView = {
        let gifView = FLAnimatedImageView()
        gifView.backgroundColor = UIColor.darkGray
        gifView.layer.borderColor = UIColor.Lime().cgColor
        gifView.layer.borderWidth = 3
        self.scrollView.addSubview(gifView)
        return gifView
    }()

    fileprivate lazy var circleButton: UIButton = {
        let circleButton = UIButton(type: .roundedRect)
        circleButton.layer.cornerRadius = 30
        circleButton.layer.borderColor = UIColor.EazeBlue().cgColor
        circleButton.layer.borderWidth = 2
        circleButton.backgroundColor = UIColor.EazeBlue()
        circleButton.addTarget(self, action: #selector(TimelineViewController.nextPressed), for: .touchUpInside)
        circleButton.layer.borderWidth = 5
        circleButton.layer.borderColor = UIColor.Purple().cgColor
        self.view.addSubview(circleButton)
        return circleButton
    }()

    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: 2)
        self.scrollView.addSubview(label)
        return label
    }()

    fileprivate lazy var timelabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Purple()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: 2)
        label.text = ""
        self.scrollView.addSubview(label)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "UnderwaterGradient")!)
        scrollView.autoPinEdgesToSuperviewEdges()

        timelabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        timelabel.autoAlignAxis(toSuperviewAxis: .vertical)
        timelabel.sizeToFit()

        gifView.autoPinEdge(.top, to: .bottom, of: timelabel, withOffset: 10)
        gifView.autoAlignAxis(toSuperviewAxis: .vertical)
        gifView.autoSetDimension(.width, toSize: self.view.frame.size.width - 20)

        label.autoPinEdge(.top, to: .bottom, of: gifView, withOffset: 10)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoSetDimension(.width, toSize: self.view.frame.size.width - 20)
        label.sizeToFit()

        circleButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 60)
        circleButton.autoAlignAxis(toSuperviewAxis: .vertical)
        circleButton.autoSetDimension(.height, toSize: 60)
        circleButton.autoSetDimension(.width, toSize: 60)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleNavBar()
        currentIndex = 0
        getPostsInRealm(index: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.size.height + 50)
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
                    })

                    let realm = try! Realm()
                    guard let this_post = realm.resolve(postRef) else { return }

                    self.label.text = this_post.text
                    let hour = Calendar.current.component(.hour, from: this_post.date as Date)
                    let minutes = Calendar.current.component(.minute, from: this_post.date as Date)
                    let minStr = (minutes < 10) ? "0" + String(minutes) : String(minutes)
                    if hour > 12 {
                        self.timelabel.text = "Today @ \(hour - 12):\(minStr) pm"
                    } else {
                        self.timelabel.text = "Today @ \(hour):\(minStr) am"
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
        currentIndex = (currentIndex != ((posts?.count)! - 1)) ? currentIndex + 1 : 0
        getPostsInRealm(index: currentIndex)
    }
}
