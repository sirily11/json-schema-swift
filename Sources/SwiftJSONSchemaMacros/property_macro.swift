import SwiftSyntax
import SwiftSyntaxMacros

public struct SchemaDescriptionMacro: PeerMacro {
    public static func expansion(
        of _: AttributeSyntax,
        providingPeersOf _: some DeclSyntaxProtocol,
        in _: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return []
    }
}
