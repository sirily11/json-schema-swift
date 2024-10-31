import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public struct SchemaDescriptionMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            let propertyError = Diagnostic(node: node, message: JSONSchemaPropertyDiagnostic.onlyProperties)
            context.diagnose(propertyError)
            return []
        }

        // get the property type
        guard let binding = varDecl.bindings.first,
              let typeAnnotation = binding.typeAnnotation?.type
        else {
            return []
        }

        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
            return []
        }

        if let exampleArg = arguments.first(where: { $0.label?.text == "example" }) {
            guard let exampleValue = ExprSyntax(exampleArg.expression) else {
                return []
            }

            // type from the property
            let propertyTypeString = typeAnnotation.description.trimmingCharacters(in: .whitespaces)
            if propertyTypeString == "String" {
                if !exampleValue.is(StringLiteralExprSyntax.self) {
                    let diagnostic = Diagnostic(node: exampleValue, message: JSONSchemaPropertyDiagnostic.typeMismatch(expectedType: "String", gotType: propertyTypeString))
                    context.diagnose(diagnostic)
                }
            } else if propertyTypeString == "Int" {
                if !exampleValue.is(IntegerLiteralExprSyntax.self) {
                    let diagnostic = Diagnostic(node: exampleValue, message: JSONSchemaPropertyDiagnostic.typeMismatch(expectedType: "Int", gotType: propertyTypeString))
                    context.diagnose(diagnostic)
                }
            } else if propertyTypeString == "Double" || propertyTypeString == "Float" {
                if !exampleValue.is(FloatLiteralExprSyntax.self) && !exampleValue.is(IntegerLiteralExprSyntax.self) {
                    let diagnostic = Diagnostic(
                        node: exampleValue,
                        message: JSONSchemaPropertyDiagnostic.typeMismatch(
                            expectedType: "Double or Float",
                            gotType: propertyTypeString
                        )
                    )
                    context.diagnose(diagnostic)
                }
            } else if propertyTypeString == "Bool" {
                if !exampleValue.is(BooleanLiteralExprSyntax.self) {
                    let diagnostic = Diagnostic(
                        node: exampleValue,
                        message: JSONSchemaPropertyDiagnostic.typeMismatch(
                            expectedType: "Bool",
                            gotType: propertyTypeString
                        )
                    )
                    context.diagnose(diagnostic)
                }
            }
        }

        return []
    }
}
