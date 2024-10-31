
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

enum JSONSchemaPropertyDiagnostic: DiagnosticMessage {
    case onlyProperties
    case typeMismatch(expectedType: String, gotType: String)

    var severity: DiagnosticSeverity { .error }

    var message: String {
        switch self {
        case .onlyProperties:
            return "This macro can only be applied to properties"
        case .typeMismatch(let expectedType, let gotType):
            return "Example type mismatch: expected '\(expectedType)' but got '\(gotType)'"
        }
    }

    var diagnosticID: MessageID {
        MessageID(domain: "SchemaDescriptionMacro", id: String(describing: self))
    }
}
