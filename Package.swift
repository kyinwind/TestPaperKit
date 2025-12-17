// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TestPaperKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "TestPaperKit",
            targets: ["TestPaperKit"]
        )
    ],
    targets: [
        .target(
            name: "TestPaperKit",
            path: "Sources/TestPaperKit"
        )
    ]
)
