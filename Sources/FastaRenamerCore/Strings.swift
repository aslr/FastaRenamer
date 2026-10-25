/// Strings
///
/// @aslr 2026
///

extension Substring {
    /// Checks for the known format of an NCBI accession number:
    /// 1-6 capital letters
    /// optional "_"
    /// >= 5 digits
    /// optional ".version"
    func isAccession() -> Bool {
        // text should be ASCII so let's access characters directly
        let characters = Array(self.utf8)
        var i = 0
        
        // A-Z
        while i < characters.count, characters[i] >= 65, characters[i] <= 90 {
            i += 1
        }
        
        // i must be between 1 and 6
        guard (1...6).contains(i) else { return false }
        
        // skip "_" if there is one
        if i < characters.count,
           characters[i] == 95 {
            i += 1
        }
        
        let digitStart = i
        
        // 0-9
        while i < characters.count, characters[i] >= 48, characters[i] <= 57 {
            i += 1
        }
        
        // digits must be 5 or higher
        guard i - digitStart >= 5 else { return false }
        
        if i < characters.count {
            // "."
            guard characters[i] == 46 else { return false }
            i += 1
            
            // 0-9
            let versionStart = i
            while i < characters.count, characters[i] >= 48, characters[i] <= 57 {
                i += 1
            }
            
            guard i > versionStart else { return false }
        }
        return i == characters.count
    }
    
    /// "Escherichia", "Bacillus": capital letter followed by letters
    func looksLikeGenus() -> Bool {
        guard let first, first.isUppercase else { return false }
        return dropFirst().allSatisfy { $0.isLetter || $0 == "-" }
    }

    /// "coli", "sapiens", "sp.": starts lowercase, letters/hyphen/dot only
    func looksLikeSpeciesEpithet() -> Bool {
        guard let first, first.isLowercase else { return false }
        return allSatisfy { $0.isLetter || $0 == "-" || $0 == "." }
    }
}
