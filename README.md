# CSCConfigLoader

[![Version](https://img.shields.io/cocoapods/v/CSCConfigLoader.svg?style=flat)](http://cocoapods.org/pods/CSCConfigLoader)
[![License](https://img.shields.io/cocoapods/l/CSCConfigLoader.svg?style=flat)](http://cocoapods.org/pods/CSCConfigLoader)
[![Platform](https://img.shields.io/cocoapods/p/CSCConfigLoader.svg?style=flat)](http://cocoapods.org/pods/CSCConfigLoader)

An easy interface for loading static configuration data (such as server names or API keys or anything else you can think of) in an iOS app.  Supports allowing a pod to provide its own defaults and override them in the main app.  Keep that config data out of the source code!

This pod is a rather thin wrapper around the iOS plist file load capabilities, but it provides a simpler interface, caching, and adds inheritance.

## Installation

CSCConfigLoader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CSCConfigLoader"
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The example project simply loads the main config and prints out a test value from it using NSLog.  There is no UI at present.  The only (mildly) interesting code is in the app delegate.

## Usage

Create your config file as a Property List file by right-clicking the directory you want it in in XCode -> New File -> Resource -> Property List.  Make sure to name your file "config".  You can then add any configuration values you wish to it.

To access your config values, first you'll need to import the library:

```
#import "CSCConfigLoader.h"
```

### Obtaining an instance

Instances are internally cached inside the library for quick access, so they only incur the loading time the first time you access them -- don't be afraid to use these methods to access keys repeatedly.  As such, the only way to create an instance is via a class method on `CSCConfigLoader`.  There are three such methods:

#### `+ (instancetype) mainConfig`
Returns an object representing the config from the main bundle.

#### `+ (instancetype) configFromBundle:(NSBundle *)bundle`
Returns an object representing the config from a specific bundle.  This is most useful for a pod developer who has their own private config inside their pod's resource bundle.

#### `+ (instancetype) mainConfigWithFallbackFrom:(NSBundle *)bundle`
Returns an object representing the config from the main bundle, but it will additionally search the config from the provided bundle if the key isn't found in the main bundle.  This is most useful for a pod developer who has defaults specified in their pod's resource bundle, but wants the main application (pod's user) to be able to override these values.

#### Loading your pod's resource bundle

Most likely, you'll want to load your pod's resource bundle by name.  This is the key specified in the dictionary to your podspec's [`resource_bundles`](http://guides.cocoapods.org/syntax/podspec.html#resource_bundles) property.  You can then load it like this:

```
[NSBundle bundleWithPath:[[NSBundle mainBundle]
            pathForResource:@"YOUR_BUNDLE_NAME"
                     ofType:@"bundle"]];
```

It may also be possible to use the `bundleForClass:` method of `NSBundle` and pass in one of your pod's classes, depending on your pod configuration.  This is beyond the scope of this documentation.

### Getting a key from an instance
All keys are available via subscript, just like the syntax for accessing keys in an NSDictionary.  Assuming an instance named `conf`, you could get the value for the key named `YOUR_KEY_HERE` like this: `conf[@"YOUR_KEY_HERE"]`.

In practice, I expect you'll mostly want to use it as a one-liner as in `[CSCConfigLoader mainConfig][@"YOUR_KEY_HERE"]`.  I hope it goes without saying to replace `YOUR_KEY_HERE` with the name of whatever key's value you want to access.

That's all there is to it!

## Author

This pod was created by Cast Social Company, specifically for use in our flagship product, [Cast](http://castapp.io).  Hopefully it's useful to someone else as well!

## License

CSCConfigLoader is available under the MIT license. See the LICENSE file for more info.
