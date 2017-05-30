//
//  PostTableViewCell.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import Foundation
import UIKit
import FLAnimatedImage
import PureLayout

public class PostTableViewCell: UITableViewCell {

    var gif : Gif?

    private lazy var gifView: FLAnimatedImageView = {
        let gifView = FLAnimatedImageView()
        gifView.backgroundColor = UIColor.darkGray
        return gifView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(gifView)
        gifView.autoPinEdgesToSuperviewEdges(with: .zero)
    }
}
