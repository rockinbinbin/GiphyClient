//
//  GifCollectionViewCell.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import Foundation
import UIKit
import FLAnimatedImage

public class GifCollectionViewCell: UICollectionViewCell {

    // MARK: - Initialization

    var delegate: ViewControllerDelegate? = nil
    var gif : Gif?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private lazy var gifView: FLAnimatedImageView = {
        let gifView = FLAnimatedImageView()
        gifView.backgroundColor = UIColor.darkGray
        return gifView
    }()

    private func setup() {
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(gifView)
        gifView.autoPinEdgesToSuperviewEdges(with: .zero)

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(GifCollectionViewCell.singleTapExpand))
        singleTap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTap)
    }

    func showGif(gif: Gif) {
        self.gif = gif
        DispatchQueue.main.async {
            self.gifView.animatedImage = gif.animated_image
        }
    }

    func loadGif(gif: Gif, gifSize: GifSize, row: Int) {
        guard let url = URL(string: gif.meta_data[gifSize.rawValue]["url"].string!) else {
            return
        }

        if url.absoluteString == "" { return }
        self.gif = gif

        DispatchQueue.global(qos: .background).async {
            gif.animated_image = FLAnimatedImage(animatedGIFData: NSData(contentsOf: url)! as Data)
            DispatchQueue.main.async {
                guard row == self.tag else { return }
                self.gifView.alpha = 0
                self.gifView.animatedImage = gif.animated_image
                UIView.animate(withDuration: 0.5, animations: {
                    self.gifView.alpha = 1
                })
                self.delegate?.cacheGif(gif: gif, row: row)
            }
        }
    }

    func removeGif() {
        self.gifView.animatedImage = nil
        self.gif = nil
    }

    func singleTapExpand() {
        guard let gif = self.gif else { return }
        DispatchQueue.main.async {
            self.delegate?.pushGifView(gif: gif)
        }
    }
}
