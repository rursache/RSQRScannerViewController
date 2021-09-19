// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "RSQRScannerViewController",
	platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "RSQRScannerViewController",          
            targets: ["RSQRScannerViewController"]),
    ],
    targets: [
        .target(
            name: "RSQRScannerViewController",
			path: "Sources"
		)
    ],
	swiftLanguageVersions: [.v5]
)
