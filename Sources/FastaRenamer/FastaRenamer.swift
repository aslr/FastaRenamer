/// FastaRenamer
///
/// @aslr 2026
///

import JavaScriptKit
import FastaRenamerCore

@main
struct FastaRenamer {
    nonisolated(unsafe) static var clickHandler: JSClosure?
    
    static func main() {
        let document = JSObject.global.document
        let inputArea = document.getElementById("inputArea")
        let outputArea = document.getElementById("outputArea")
        let statusArea = document.getElementById("statusArea")
        let formatButton = document.getElementById("formatBtn")
        let removeVersionBox = document.getElementById("removeVersion")
        
        let handler = JSClosure { _ in
            let text = inputArea.value.string ?? ""
            let removeVersion = removeVersionBox.checked.boolean ?? false
            let result = FastaRenamerCore.rename(text, removeVersion: removeVersion)
            outputArea.value = .string(result.name)
            
            let headers = result.count == 1 ? "header" : "headers"
            var status = "\(result.count) \(headers) renamed."
            
            if !result.warnings.isEmpty {
                status += "\n" + result.warnings.joined(separator: "\n")
            }
            statusArea.textContent = .string(status)
            return .undefined
        }
        clickHandler = handler
        formatButton.onclick = .object(handler)
    }
}
