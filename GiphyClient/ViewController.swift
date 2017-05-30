//
//  ViewController.swift
//  GiphyClient
//
//  Created by Robin Mehta on 5/30/17.
//  Copyright © 2017 robin. All rights reserved.
//

import UIKit
import PureLayout
import SwiftyJSON
import FLAnimatedImage
import CHTCollectionViewWaterfallLayout

class ViewController: UIViewController {

    var searchController : UISearchController = UISearchController()
    var searchResultsCollectionViewController = UICollectionViewController()

    fileprivate lazy var collectionView: UICollectionView = {
        let waterfallLayout = CHTCollectionViewWaterfallLayout()
        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: waterfallLayout)
        collectionView.dataSource  = self
        collectionView.delegate = self
        collectionView.configureCollectionView()
        return collectionView
    }()

    fileprivate lazy var searchCollectionView: UICollectionView = {
        let waterfallLayout = CHTCollectionViewWaterfallLayout()
        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: waterfallLayout)
        collectionView.dataSource  = self
        collectionView.delegate = self
        collectionView.configureCollectionView()
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        createSearchController()
        self.navigationController?.navigationBar.styleNavBar()
        self.tabBarController?.navigationItem.titleView = self.searchController.searchBar

        Model.sharedInstance.dataDelegate = self

        self.view.addSubview(collectionView)
        setupCollectionView(collectionView: self.collectionView)

        self.automaticallyAdjustsScrollViewInsets = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = true
    }

    func createSearchController() {
        let searchResultsCollectionView = searchCollectionView
        setupCollectionView(collectionView: searchResultsCollectionView)

        self.searchResultsCollectionViewController = UICollectionViewController()
        self.searchResultsCollectionViewController.collectionView = searchResultsCollectionView

        self.searchController = UISearchController(searchResultsController: self.searchResultsCollectionViewController)

        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        self.searchController.hidesNavigationBarDuringPresentation = false

        self.searchController.searchBar.placeholder = "Search"
        self.searchController.searchBar.barTintColor = UIColor.white
        self.searchController.searchBar.tintColor = UIColor.black
        self.searchController.searchBar.layer.borderColor = UIColor.clear.cgColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (Model.sharedInstance.trendingJSON == nil) {
            DispatchQueue.global(qos: .default).async {
                Model.sharedInstance.getTrendingGifs()
            }
        }
    }

    func setupCollectionView(collectionView: UICollectionView) {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 3.0
        layout.minimumInteritemSpacing = 3.0
        layout.headerHeight = 3.0

        collectionView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UISearchControllerDelegate, UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var text = searchBar.text
        text = text?.createSearchString()
        let parameters = ["q":text ?? "", "offset":"0", "rating":"pg", "fmt":"json", "sort":"relevant", "limit":"500"] as [String : Any]
        Model.sharedInstance.getSearchGifs(parameters: parameters as [String : AnyObject])
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Model.sharedInstance.isSearching ? Model.sharedInstance.getNumSearchGifs() : Model.sharedInstance.getNumTrendingGifs()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! GifCollectionViewCell

        cell.removeGif()
        cell.tag = indexPath.row

        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.delegate = self

        let json : JSON? = Model.sharedInstance.isSearching ? Model.sharedInstance.searchJSON : Model.sharedInstance.trendingJSON
        let cache : NSCache = Model.sharedInstance.isSearching ? Model.sharedInstance.searchCache : Model.sharedInstance.trendingCache

        guard let json_ = json else {
            return cell
        }

        if let gif = cache.object(forKey: indexPath.row as AnyObject) {
            cell.showGif(gif: gif)
        }
        else {
            let gif = Gif(meta_data: json_["data"][indexPath.row]["images"])
            cell.loadGif(gif: gif, gifSize: .fixed_width, row: indexPath.row)
        }
        return cell
    }

    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let height = scrollView.frame.size.height
    //        let contentYoffset = scrollView.contentOffset.y
    //        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
    //        if distanceFromBottom < height {
    //            self.searchController.startActivityIndicator()
    //            Model.sharedInstance.isSearching ? Model.sharedInstance.getNextSearchOffset() : Model.sharedInstance.getNextTrendingOffset()
    //        }
    //    }
}

extension ViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return Model.sharedInstance.getGifSize(index: indexPath.row, gifSize: .fixed_width)
    }
}

extension ViewController: DataDelegate {
    func passJSON(json: JSON, newSearch: Bool, isSearching: Bool) {
        if newSearch {
            Model.sharedInstance.searchCache.removeAllObjects()
        }
        DispatchQueue.main.async() {
            newSearch ? self.searchResultsCollectionViewController.collectionView?.reloadData() : self.collectionView.reloadData()
        }
    }
}

extension ViewController: CacheDelegate {
    func passGif(gif: Gif, row: Int) {

        if Model.sharedInstance.isSearching {
            Model.sharedInstance.searchCache.setObject(gif, forKey: row as AnyObject)
        }
        else {
            Model.sharedInstance.trendingCache.setObject(gif, forKey: row as AnyObject)
        }
    }
}


