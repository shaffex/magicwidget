// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MagicWidget",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "MagicWidget",
            targets: ["MagicWidget"]),
    ],
    dependencies: [
        .package(url: "https://gitlab.com/peter.popovec/magicui-framework-beta", branch: "main"),
    ],
    targets: [
        .target(
            name: "MagicWidget",
            dependencies: [
                .product(name: "MagicUi", package: "magicui-framework-beta")
            ],
            path: "MagicWidget/Sources"
        )
    ]
)
