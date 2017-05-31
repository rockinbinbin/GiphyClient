//
//  Timeline.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import Foundation
import UIKit

// Use this

class TimelineViewController: UIViewController {
//    fileprivate lazy var navBarTitleText: UILabel = {
//        let text = UILabel()
//        text.textColor = UIColor.EazeBlue()
//        text.numberOfLines = 0
//        text.textAlignment = .center
//        text.text = "M👀d"
//        return text
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "UnderwaterGradient")!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleNavBar()
    }

    func styleNavBar() {
        self.navigationController?.navigationBar.styleNavBar()
        self.tabBarController?.navigationItem.titleView = nil
        let titleLabel = UILabel()
        let attributes: NSDictionary = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: 5.0),
            NSForegroundColorAttributeName: UIColor.EazeBlue(),
            NSKernAttributeName: CGFloat(5)
        ]
        let attributedTitle = NSAttributedString(string: "M👀D", attributes: attributes as? [String : AnyObject])

        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.tabBarController?.navigationItem.titleView = titleLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
