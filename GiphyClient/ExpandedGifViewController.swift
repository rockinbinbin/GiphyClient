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
import RealmSwift

// Use this view to type Gif caption and post to story

class ExpandedGifViewController: UIViewController, UITextViewDelegate {

    var gif : Gif

    public init(gif: Gif) {
        self.gif = gif
        super.init(nibName: nil, bundle: nil)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: self.view.frame)
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        return scrollView
    }()

    private lazy var textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.textColor = UIColor.Blue()
        textView.backgroundColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 18, weight: 2)
        textView.textAlignment = .left
        textView.layer.borderColor = UIColor.Purple().cgColor
        textView.layer.borderWidth = 3
        textView.delegate = self
        textView.placeholder = "Say what's up 😎"
        self.scrollView.addSubview(textView)
        return textView
    }()

    private lazy var gifView: FLAnimatedImageView = {
        let gifView = FLAnimatedImageView()
        gifView.backgroundColor = UIColor.clear
        gifView.layer.borderColor = UIColor.Purple().cgColor
        gifView.layer.borderWidth = 3
        gifView.contentMode = .scaleToFill
        self.scrollView.addSubview(gifView)
        return gifView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "SunriseGradient")!)
        scrollView.autoPinEdgesToSuperviewEdges()

        self.navigationController?.navigationBar.styleNavBar()
        let button1 = UIBarButtonItem(image: UIImage(named: "Send"), style: .plain, target: self, action: #selector(ExpandedGifViewController.sendClicked))
        self.navigationItem.rightBarButtonItem  = button1
        self.navigationItem.styleTitleView(str: "Post to Story")

        textView.autoSetDimension(.width, toSize: self.view.frame.size.width - 20)
        textView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        textView.autoAlignAxis(toSuperviewAxis: .vertical)
        textView.autoSetDimension(.height, toSize: 150)

        gifView.autoPinEdge(.top, to: .bottom, of: textView, withOffset: 10)
        gifView.autoSetDimension(.width, toSize: self.view.frame.size.width - 20)
        gifView.autoAlignAxis(toSuperviewAxis: .vertical)

        self.loadGif(gif: self.gif, gifSize: .original)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let size = gif.getSize(gifSize: .original)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: size.height + 200)
    }

    func loadGif(gif: Gif, gifSize: GifSize) {
        guard let url = URL(string: gif.meta_data[gifSize.rawValue]["url"].string!) else { return }
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

    func sendClicked() {
        let post = Post()
        post.date = NSDate()

        if let encryptedData : NSData = try! gif.meta_data.rawData() as NSData {
            post.gif_data = encryptedData
        }
        post.text = textView.text

        let realm = try! Realm()
        try! realm.write {
            realm.add(post)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
