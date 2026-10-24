/// FastaRenamer
///
/// @aslr 2026
///

public struct FastaResult {
    public var name: String
    public var count: Int
    public var warnings: [String]
}

/// Rewrites all FASTA sequence names to the format taxon_name_accession
public enum FastaRenamer {
    public static func rename(_ input: String) -> FastaResult {
        var results = [String]()
        var count = 0
        var warnings = [String]()
        
        let lines = input.split(separator: "\n",
                                omittingEmptySubsequences: false)
        
        for (i, line) in lines.enumerated() {
            guard line.hasPrefix(">") else {
                results.append(String(line))
                continue
            }
            
            // preserve Windows line endings
            let hasCR = line.hasSuffix("\r")
            let cleanLine = hasCR ? line.dropLast() : line
            
            if let newName = renameHeader(cleanLine) {
                results.append(">" + newName + (hasCR ? "\r" : ""))
                count += 1
            } else {
                results.append(String(cleanLine))
                warnings.append("Line \(i + 1): taxon [..] or accession number not found, header left unchanged.")
            }
        }
        let result = FastaResult(name: results.joined(separator: "\n"),
                                 count: count,
                                 warnings: warnings)
        return result
    }
    
    static func renameHeader(_ header: Substring) -> String? {
        var body = String(header.dropFirst()) // drop ">"
        
        guard let close = body.lastIndex(of: "]") else { return nil }
        guard let open = body[..<close].lastIndex(of: "[") else { return nil }
        let taxon = String(body[body.index(after: open)..<close])
        body.removeSubrange(open...close)
        
        guard let cleanTaxon = cleanTaxon(raw: taxon) else { return nil }
        
        let tokens = body.split(whereSeparator: {" \t|,;".contains($0)} )
        guard let accession = tokens.first(where: { $0.isAccession() } )
                else { return nil }
        return cleanTaxon + "_" + accession
    }
    
    /// Removes problematic characters for phylogeny software
    static func cleanTaxon(raw: String) -> String? {
        let unwanted: Set<Character> = ["(", ",", "[", "]", ":", ";", ",", "'", "\"", "/", "\\", "|"]
        var components = [String]()
        for word in raw.split(whereSeparator: { $0 == " " || $0 == "\t" }) {
            let cleanName = String(word.filter { !unwanted.contains($0) })
            if !cleanName.isEmpty { components.append(cleanName) }
        }
        return components.isEmpty ? nil : components.joined(separator: "_")
    }
}


