// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TestPaper",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "TestPaper",
            targets: ["TestPaper"]
        )
    ],
    targets: [
        .target(
            name: "TestPaper",
            path: "Sources/TestPaper"
        )
    ]
)
