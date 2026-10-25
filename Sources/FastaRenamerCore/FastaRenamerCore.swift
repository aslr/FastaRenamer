/// FastaRenamerCore
///
/// @aslr 2026
///

public struct FastaResult {
    public var name: String
    public var count: Int
    public var warnings: [String]
}

/// Rewrites all FASTA sequence names to the format taxon_name_accession
/// Parameters:
///  input: string to be renamed
///  removeVersion: pass true if you want to remove the version from the accession number
public struct FastaRenamerCore {
    public static func rename(_ input: String,
                              removeVersion: Bool = false) -> FastaResult {
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
            
            if let newName = renameHeader(cleanLine, removeVersion: removeVersion) {
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
    
    static func renameHeader(_ header: Substring,
                             removeVersion: Bool) -> String? {
        var body = String(header.dropFirst()) // drop ">"
        var taxon: String?
        
        // Case 1: taxon between [] (BLASTp hit page format)
        if let close = body.lastIndex(of: "]"),
           let open = body[..<close].lastIndex(of: "[") {
            guard let cleanedTaxon = cleanTaxon(raw: String(body[body.index(after: open)..<close]))
            else { return nil }
            taxon = cleanedTaxon
            body.removeSubrange(open...close)
        }
        
        let tokens = body.split(whereSeparator: {" \t|,;".contains($0)} )
        guard let accessionIndex = tokens.firstIndex(where: { $0.isAccession() } )
            else { return nil }
        var accession = tokens[accessionIndex]
        
        // Case 2: no [] taxon (BLASTn format):
        // ">ACCESSION.VERSION Genus species strain ... description"
        if taxon == nil {
            taxon = taxonAfterAccession(tokens[(accessionIndex + 1)...])
        }
        guard let taxon else { return nil }
        
        if removeVersion, let dot = accession.firstIndex(of: ".") {
            accession = accession[..<dot]
        }
        
        return taxon + "_" + accession
    }
    
    /// Takes "Genus species" (or "Candidatus Genus species") from the words
    /// that follow the accession. Returns nil if they do not look like a binomial name.
    static func taxonAfterAccession(_ words: ArraySlice<Substring>) -> String? {
        var rest = words
        var parts = [Substring]()
        
        // Keep the Candidatus prefix as part of the taxon name
        if let first = rest.first, first == "Candidatus" {
            parts.append(first)
            rest = rest.dropFirst()
        }
        
        guard let genus = rest.first,
              let species = rest.dropFirst().first,
              genus.looksLikeGenus(),
              species.looksLikeSpeciesEpithet()
        else { return nil }
        
        parts.append(genus)
        parts.append(species)
        return cleanTaxon(raw: parts.joined(separator: " "))
    }
    
    /// Removes problematic characters for phylogeny software
    static func cleanTaxon(raw: String) -> String? {
        let unwanted: Set<Character> = ["(", ")", "[", "]", ":", ";", ",", "'", "\"", "/", "\\", "|"]
        var components = [String]()
        for word in raw.split(whereSeparator: { $0 == " " || $0 == "\t" }) {
            let cleanName = String(word.filter { !unwanted.contains($0) })
            if !cleanName.isEmpty { components.append(cleanName) }
        }
        return components.isEmpty ? nil : components.joined(separator: "_")
    }
}


