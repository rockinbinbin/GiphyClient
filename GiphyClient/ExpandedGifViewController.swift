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

class ExpandedGifViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        self.navigationController?.navigationBar.styleNavBar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
