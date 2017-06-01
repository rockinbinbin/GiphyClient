# GiphyClient
 😹🔥 FIG – Client app using the Giphy API (http://giphy.com) for trending &amp; search. Create a daily story of GIFs that match your mood. [Swift 3, Realm] 

#Requirements
iOS 9.0
XCode 8
Swift 3
Cocoapods

#Run the app
Install dependencies via Cocoapods (http://cocoapods.org):

```shell
$ pod install
```

Open GiphyClient.xcworkspace, and build the app!

# What
*Architecture:*
* [x] MVC
* [x] Local persistence: Realm (https://realm.io)
* [x] Protocol Extensions, Generics, Closures, etc..
* [x] Migrate to Swift 3

Future Considerations:
* [ ] Pagination for search results
* [ ] Error handling
* [ ] Unit-tests

*Features:*
* [x] Trending GIFs
* [x] Search GIF by term
* [x] Caching GIFs for fast access
* [x] Add Gifs to your daily story

#Frameworks Used
PureLayout [API for iOS & OS X Auto Layout]: https://github.com/PureLayout/PureLayout
SwiftyJSON: https://github.com/SwiftyJSON/SwiftyJSON
FLAnimatedImage [Performant animated GIF engine for iOS]: https://github.com/Flipboard/FLAnimatedImage
Realm [Open-source object database management system]: https://realm.io
CHTCollectionViewWaterfallLayout: https://github.com/chiahsien/CHTCollectionViewWaterfallLayout
String / Dictionary Extensions [Percent Encoding, String from HTTP Params]: http://www.ietf.org/rfc/rfc3986.txt
Search Phrase Extension: https://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
UITextView Placeholder Extension: https://finnwea.com/blog/adding-placeholders-to-uitextviews-in-swift
