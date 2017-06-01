# FIG – iOS Client using the Giphy API
🌀 FIG – Client app using the Giphy API (http://giphy.com) for trending &amp; search. Create a daily story of GIFs that match your mood.
 
![alt text](https://raw.githubusercontent.com/rockinbinbin/GiphyClient/master/giphy.gif) 
![alt text](https://raw.githubusercontent.com/rockinbinbin/GiphyClient/master/better.gif)

## Requirements
* iOS 9.0
* XCode 8
* Swift 3
* Cocoapods

#### Run the app
Install dependencies via Cocoapods (http://cocoapods.org):

```shell
$ pod install
```

Open GiphyClient.xcworkspace, and run the app! 😎

## Features
* [x] Trending GIFs 📈
* [x] Search GIF by term 🔍
* [x] Caching GIFs for fast access 🏃
* [x] Post Gifs + text to your daily story 🌞
* [x] Local persistence of your story 🌊

Implemented this app in MVC, using a Model to handle retrieving JSON for trending and search queries. Images are loaded async as needed, and cached in the model. Upon creating a post, Realm (https://realm.io) handles persistent storage & retrieval of today's posts, in descending order by date, like a story in Snapchat or Messenger.

## Future Considerations:
* Paging search results (currently loads 500 GIFs fairly quickly) 📃
* Error handling 🐞
* Unit-testing 🤓
* Consider MVVM / ReactiveCocoa for larger projects
* Design for icons, animations, etc.

## Frameworks
* PureLayout [API for iOS & OS X Auto Layout]: https://github.com/PureLayout/PureLayout
* SwiftyJSON: https://github.com/SwiftyJSON/SwiftyJSON
* FLAnimatedImage [Performant animated GIF engine for iOS]: https://github.com/Flipboard/FLAnimatedImage
* Realm [Open-source object database management system]: https://realm.io
* CHTCollectionViewWaterfallLayout: https://github.com/chiahsien/CHTCollectionViewWaterfallLayout
* String / Dictionary Extensions [Percent Encoding, String from HTTP Params]: http://www.ietf.org/rfc/rfc3986.txt
* Search Phrase Extension: https://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
* UITextView Placeholder Extension: https://finnwea.com/blog/adding-placeholders-to-uitextviews-in-swift
