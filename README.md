# SLazeKit

<p align="center">
    <a href="http://swift.org">
        <img src="https://img.shields.io/badge/Swift-4.0-brightgreen.svg" alt="Language" />
        </a>
        <a href="https://raw.githubusercontent.com/shial4/SLazeKit/master/LICENSE">
            <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License" />
        </a>
        <a href="https://cocoapods.org/pods/SLazeKit">
            <img src="https://img.shields.io/cocoapods/v/SLazeKit.svg" alt="CocoaPods" />
        </a>
        <a href="https://github.com/Carthage/Carthage">
            <img src="https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat" alt="Carthage" />
        </a>
</p>

SLazeKit is an easy to use Swift restfull collection of extensions and classes. Don't spend hours writing your code to map your rest api request into models and coredata serialization. Stop wasting your time!

**SLazeKit allows you:**
- map your models by  `Codable` protocol
- serialize `CoreData` models from API response
- fast and simple extend your models with `API` & `CoreData`

## 🔧 Installation

**CocoaPods:**

Add the line `pod "SLazeKit"` to your `Podfile`

**Carthage:**

Add the line `github "shial4/SLazeKit"` to your `Cartfile`

**Manual:**

Clone the repo and drag the folder `SLazeKit` into your Xcode project.

**Swift Package Manager:**

Add the line `.package(url: "https://github.com/shial4/SLazeKit.git", from: "0.1.0"),` to your `Package.swift`

**Swift Package Manager in your iOS Project:**
This project demonstrates a working method for using Swift Package Manager (SPM) to manage the dependencies of an iOS project.

<a href="https://github.com/j-channings/swift-package-manager-ios">Example of how to use SPM v4 to manage iOS dependencies</a>

## 💊 Usage

For positive experience, you should configure `SLazeKit` at first. This step is optional. You may leave it as it is default.

```swift
import SLazeKit
extension SLazeKit {
    //Provide base path for your API requests.
    open class var basePath?: String { return "www.yourdomain.com" }
    //Additional you can set port for your requests.
    open class var basePort: Int? { return 8040  }
    //You can provide your own instance of JSONDecoder.
    open class var decoder: JSONDecoder { return JSONDecoder() }
    //You can customize instance of URLSession in here.
    open class var urlSession: URLSession { return URLSession.shared }
    
    //If you feel like to set header dor requests do it in here.
    open class func setup(_ request: URLRequest) -> URLRequest {
        var request: URLRequest = request
        request.setValue("Your token", forHTTPHeaderField: "X-Access-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    //If you feel like to monitor response. You can do it in here.
    open class func handle(_ response: HTTPURLResponse?) {
        if response?.statusCode == 401 {
            Client.logout()
        }
    }
}
```

**Model example**
[Model.swift](Tests/SLazeKitTests/Models/Model.swift)

## ⭐ Contributing

Be welcome to contribute to this project! :)

## ❓ Questions

Just create an issue on GitHub.

## 📝 License

This project was released under the [MIT](LICENSE) license.
