//
//  Extensions.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import Foundation
import UIKit
import FLAnimatedImage

public extension UIColor {
    class func EazeBlue() -> UIColor {
        return UIColor(red:0.16, green:0.63, blue:0.91, alpha:1.0)
    }
    class func Purple() -> UIColor {
        return UIColor(red:0.41, green:0.26, blue:0.85, alpha:1.0)
    }
    class func Blue() -> UIColor {
        return UIColor(red:0.25, green:0.57, blue:0.96, alpha:1.0)
    }
    class func Lime() -> UIColor {
        return UIColor(red:0.69, green:0.96, blue:0.25, alpha:1.0)
    }
}

extension UICollectionView {
    func configureCollectionView() {
        self.backgroundColor = UIColor(patternImage: UIImage(named: "SunriseGradient")!)
        self.showsVerticalScrollIndicator = false
        self.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension UINavigationBar {
    func styleNavBar() {
        self.barTintColor = UIColor.white
        self.isTranslucent = false
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UINavigationItem {
    func styleTitleView(str: String) {
        let titleLabel = UILabel()
        let attributes: NSDictionary = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: 5.0),
            NSForegroundColorAttributeName: UIColor.EazeBlue(),
            NSKernAttributeName: CGFloat(5)
        ]
        let attributedTitle = NSAttributedString(string: str, attributes: attributes as? [String : AnyObject])
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.titleView = titleLabel
    }
}

extension String {
    // Source: http://www.ietf.org/rfc/rfc3986.txt
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }

    // Source: https://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
    func createSearchString() -> String? {
        let replaced = String(self.characters.map {
            $0 == " " ? "+" : $0
        })
        return replaced
    }
}

extension Dictionary {
    // Source: http://www.ietf.org/rfc/rfc3986.txt
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        return parameterArray.joined(separator: "&")
    }
}
