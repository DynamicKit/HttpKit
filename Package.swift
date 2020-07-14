// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HttpKit",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v8),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "HttpKit",
            targets: ["HttpKit"]),
    ],
    dependencies: [.package(url: "https://github.com/Alamofire/Alamofire.git",
                            from: "5.2.0")],
    targets: [
        .target(
            name: "HttpKit",
            path: "Source"
        ),
        .testTarget(
            name: "HttpKitTests",
            dependencies: ["HttpKit"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
