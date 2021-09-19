# RSQRScannerViewController

## Setup
- In your `Info.plist` add the key `NSCameraUsageDescription` with value `We are using the camera to scan QR codes` (or anything you see fit)

## Usage

Wherever you want to scan a QR code, just call
```swift
let qrScanner = RSQRScannerViewController()
qrScanner.scanResult = { result in
    print(result)
}
qrScanner.failedInit = {
    print("Failed to init capture device")
}
self.present(qrScanner, animated: true)
```

## License

RSQRScannerViewController is available under the **MPL-2.0 license**. See the [LICENSE](https://github.com/rursache/RSQRScannerViewController/blob/master/LICENSE) file for more info.
