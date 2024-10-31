import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(SwiftJSONSchemaMacros)
    import SwiftJSONSchemaMacros

    let testMacros: [String: Macro.Type] = [
        "Schema": JSONSchemaMacro.self,
        "Property": SchemaDescriptionMacro.self,
    ]
#endif

final class SwiftJSONSchemaTests: XCTestCase {
    func testGenerateSimpleSchema() throws {
        #if canImport(SwiftJSONSchemaMacros)
            assertMacroExpansion(
                """
                @Schema
                struct Person {
                    @Property(description: "The name of the person", example: "Some name")
                    var name: String
                }
                """,
                expandedSource:
                """
                struct Person {
                    var name: String

                    static func jsonSchema() -> [String: Any] {
                        return [
                            "type": "object",
                            "properties": [
                                "name": [
                      "type": "string",
                      "required": true,
                      "description": "The name of the person",
                      "example": "Some name"]
                            ]
                        ]
                    }
                }
                """,
                macros: testMacros
            )
        #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testGenerateNestedSchema() throws {
        #if canImport(SwiftJSONSchemaMacros)
            assertMacroExpansion(
                """
                @Schema
                struct Item {
                    @Property(description: "The name of the person", example: "Some name")
                    var name: String
                }

                @Schema
                struct Person {
                    @Property(description: "The item")
                    var item: Item
                }
                """,
                expandedSource:
                """
                struct Item {
                    var name: String

                    static func jsonSchema() -> [String: Any] {
                        return [
                            "type": "object",
                            "properties": [
                                "name": [
                      "type": "string",
                      "required": true,
                      "description": "The name of the person",
                      "example": "Some name"]
                            ]
                        ]
                    }
                }
                struct Person {
                    var item: Item

                    static func jsonSchema() -> [String: Any] {
                        return [
                            "type": "object",
                            "properties": [
                                "item": [
                      "type": "object",
                                                  "properties": Item.jsonSchema() ["properties"] as! [String: Any],
                      "required": true,
                      "description": "The item"]
                            ]
                        ]
                    }
                }
                """,
                macros: testMacros
            )
        #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testGenerateArraySchema() throws {
        #if canImport(SwiftJSONSchemaMacros)
            assertMacroExpansion(
                """
                @Schema
                struct Item {
                    @Property(description: "The name of the person", example: "Some name")
                    var name: String
                }

                @Schema
                struct Person {
                    @Property(description: "Items")
                    var item: [Item]
                }
                """,
                expandedSource:
                """
                struct Item {
                    var name: String

                    static func jsonSchema() -> [String: Any] {
                        return [
                            "type": "object",
                            "properties": [
                                "name": [
                      "type": "string",
                      "required": true,
                      "description": "The name of the person",
                      "example": "Some name"]
                            ]
                        ]
                    }
                }
                struct Person {
                    var item: [Item]

                    static func jsonSchema() -> [String: Any] {
                        return [
                            "type": "object",
                            "properties": [
                                "item": [
                      "type": "array",
                                                  "items": [
                                                     "type": "object",
                                                         "properties": Item.jsonSchema() ["properties"] as! [String: Any]

                                                      ],
                      "required": true,
                      "description": "Items"]
                            ]
                        ]
                    }
                }
                """,
                macros: testMacros
            )
        #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
