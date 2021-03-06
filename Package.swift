// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "HTTPClient",
        products: [
          // Products define the executables and libraries a package produces, and make them visible to other packages.
          .library(
                  name: "HTTPClient",
                  targets: ["HTTPClient"]),
        ],
        dependencies: [
          .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", .upToNextMajor(from: "9.1.0")),
        ],
        targets: [
          // Targets are the basic building blocks of a package. A target can define a module or a test suite.
          // Targets can depend on other targets in this package, and on products in packages this package depends on.
          .target(
                  name: "HTTPClient",
                  dependencies: []),
          .testTarget(
                  name: "HTTPClientTests",
                  dependencies: [
                    .target(name: "HTTPClient"),
                    .product(name: "OHHTTPStubs", package: "OHHTTPStubs"),
                    .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
                  ],
                  resources: [
                    .process("Fixtures")
                  ]
          ),
        ]
)
