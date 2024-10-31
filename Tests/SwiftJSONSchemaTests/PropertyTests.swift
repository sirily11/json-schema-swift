import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class PropertyTests: XCTestCase {
    func testIntExample() throws {
        #if canImport(SwiftJSONSchemaMacros)
            assertMacroExpansion(
                """
                @Schema
                struct Person {
                    @Property(description: "The name of the person", example: 1)
                    var age: Int
                }
                """,
                expandedSource:
                """
                struct Person {
                    var age: Int

                    static func jsonSchema() -> [String: Any] {
                        return [
                            "type": "object",
                            "properties": [
                                "age": [
                      "type": "number",
                      "required": true,
                      "description": "The name of the person",
                      "example": 1]
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

    func testFloatExample() throws {
        #if canImport(SwiftJSONSchemaMacros)
            assertMacroExpansion(
                """
                @Schema
                struct Person {
                    @Property(description: "The name of the person", example: 1)
                    var age: Float
                }
                """,
                expandedSource:
                """
                struct Person {
                    var age: Float

                    static func jsonSchema() -> [String: Any] {
                        return [
                            "type": "object",
                            "properties": [
                                "age": [
                      "type": "number",
                      "required": true,
                      "description": "The name of the person",
                      "example": 1]
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
