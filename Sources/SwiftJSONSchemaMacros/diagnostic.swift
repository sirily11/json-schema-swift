
import SwiftDiagnostics

enum JSONSchemaDiagnostic: String, DiagnosticMessage {
    case onlyStructs = "@JSONSchema can only be applied to structs"

    var message: String {
        return rawValue
    }

    var severity: DiagnosticSeverity {
        return .error
    }

    var diagnosticID: MessageID {
        MessageID(domain: "json_SchemaMacro", id: rawValue)
    }
}
