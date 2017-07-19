# Hotaru

[![CI Status](https://img.shields.io/travis/rust-lang/rust.svg)](https://travis-ci.org/hujewelz/Hotaru)
[![Version](https://img.shields.io/cocoapods/v/Hotaru.svg?style=flat)](http://cocoapods.org/pods/Hotaru)
[![License](https://img.shields.io/cocoapods/l/Hotaru.svg?style=flat)](http://cocoapods.org/pods/Hotaru)
[![Platform](https://img.shields.io/cocoapods/p/Hotaru.svg?style=flat)](http://cocoapods.org/pods/Hotaru)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

It is easy to use Hotaru:

```
Provider<UserApi>(.users).JSONData { (response) in
    let res = response.map{ User($0["data"] as! [String : Any]) }
    guard let user = res.value else {
        return
    }
            
    print(user)
}

```

## Requirements


Swift Version | iOS Version
---------- | --------
 3.x | >= 8.0


## Installation

Hotaru is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Hotaru"
```

## Author

huluobobo, hujewelz@163.com

## License

Hotaru is available under the MIT license. See the LICENSE file for more info.


