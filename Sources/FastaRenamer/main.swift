/// FastaRenamer main
///
/// @aslr 2026
///

import JavaScriptKit
import FastaRenamerCore

let document = JSObject.global.document
let inputArea = document.getElementById("inputArea").object!
let outputArea = document.getElementById("outputArea").object!
let statusArea = document.getElementById("statusArea").object!
let formatBtn = document.getElementByID("formatBtn").object!

let onClick = JSClosure { _ in
    let text = inputArea.value.string ?? ""
    let result = FastaRenamer.rename(text)
    outputArea.value = .string(result.name)
    
    let headers = result.count == 1 ? "header" : "headers"
    var status = "\(result.count) \(headers) renamed."
    
    if !result.warnings.isEmpty {
        status += "\n" + result.warnings.joined(separator: "\n")
    }
    statusArea.textContent = .string(status)
    return .undefined
}

_ = formatBtn.addEventListener!("click", onClick)
