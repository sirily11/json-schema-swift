# SwiftJSONSchema

Swift JSON Schema is a Swift library that provides the simpliest way to convert your swift object to JSON Schema
using the power of Swift Macros.

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/sirily11/json-schema-swift", from: "0.1.0")
```

## Usage

```swift
import Foundation
import SwiftJSONSchema

@Schema
struct Item {
    @Property(description: "The name of the person", example: "Some name")
    var name: String
}

@Schema
struct Person {
    @Property(description: "Items")
    var items: [Item]
}

let schema = Person.jsonSchema()
print(schema)
```
