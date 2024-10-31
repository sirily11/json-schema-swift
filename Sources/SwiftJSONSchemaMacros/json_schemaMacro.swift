import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct JSONSchemaPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        JSONSchemaMacro.self,
        SchemaDescriptionMacro.self,
    ]
}
