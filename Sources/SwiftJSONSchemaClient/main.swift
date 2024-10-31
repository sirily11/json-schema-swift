import Foundation
import SwiftJSONSchema

@Schema
struct Item {
    @Property(description: "The name of the person", example: "Some name")
    var name: String

    @Property(description: "", example: 1)
    var age: Int
}

@Schema
struct Person {
    @Property(description: "Items")
    var items: [Item]
}

let schema = Person.jsonSchema()
print(schema)
