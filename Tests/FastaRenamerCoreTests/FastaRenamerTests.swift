/// FastaRenamerTests
///
/// @aslr 2026
///

import XCTest
@testable import FastaRenamerCore

final class FastaRenamerTests: XCTestCase {
    func testNCBIHitPageOrder() {
        let r = FastaRenamerCore.rename(">NP_000509.1 hemoglobin subunit beta [Homo sapiens]\nMVHLTPEEK\n")
        XCTAssertEqual(r.name, ">Homo_sapiens_NP_000509.1\nMVHLTPEEK\n")
    }
    
    func testNCBIHitPageOrderWithoutAccessionVersion() {
        let r = FastaRenamerCore.rename(">NP_000509.1 hemoglobin subunit beta [Homo sapiens]\nMVHLTPEEK\n", removeVersion: true)
        XCTAssertEqual(r.name, ">Homo_sapiens_NP_000509\nMVHLTPEEK\n")
    }
    
    func testTaxonFirstOrder() {
        let r = FastaRenamerCore.rename(">[Mus musculus] hemoglobin beta-1 XP_006497123.1\nMVHLTDAEK")
        XCTAssertEqual(r.name, ">Mus_musculus_XP_006497123.1\nMVHLTDAEK")
    }
    
    func testPipedAndBracketsInDescription() {
        let r = FastaRenamerCore.rename(">gi|12345|ref|NP_001234.2| protein [NAD(P)H] [Escherichia coli str. K-12]\nACGT")
        XCTAssertEqual(r.name, ">Escherichia_coli_str._K-12_NP_001234.2\nACGT")
    }
    
    func testAnnotathonFastaOutput() {
        let r = FastaRenamerCore.rename(">BPPPP1   E-value=1e-44   Score=156  Bacteria;Pseudomonadati;Planctomycetes;Phycisphaerae;Phycisphaerales; MEZ6191711.1 MAG: A/G-specific adenine glycosylase [Phycisphaerales bacterium]\nMAKATTATEP")
        XCTAssertEqual(r.name, ">Phycisphaerales_bacterium_MEZ6191711.1\nMAKATTATEP")
    }
    
    func testAnnotathonFastaOutputWithoutAccessionVersion() {
        let r = FastaRenamerCore.rename(">BPPPP1   E-value=1e-44   Score=156  Bacteria;Pseudomonadati;Planctomycetes;Phycisphaerae;Phycisphaerales; MEZ6191711.1 MAG: A/G-specific adenine glycosylase [Phycisphaerales bacterium]\nMAKATTATEP", removeVersion: true)
        XCTAssertEqual(r.name, ">Phycisphaerales_bacterium_MEZ6191711\nMAKATTATEP")
    }
    
    func testMissingPartLeavesHeaderAndWarns() {
        let r = FastaRenamerCore.rename(">something odd\nACGT")
        XCTAssertEqual(r.name, ">something odd\nACGT")
        XCTAssertEqual(r.warnings.count, 1)
    }
    
    func testBlastSelectedSequencesFormat() {
        let r = FastaRenamerCore.rename(">NR_074334.1 Escherichia coli strain K-12 16S ribosomal RNA\nACGT")
        XCTAssertEqual(r.name, ">Escherichia_coli_NR_074334.1\nACGT")
    }

    func testBlastFormatRemoveVersion() {
        let r = FastaRenamerCore.rename(">MK123456.1 Bacillus subtilis subsp. subtilis str. 168 cytochrome b gene, partial cds\nACGT",
                                        removeVersion: true)
        XCTAssertEqual(r.name, ">Bacillus_subtilis_MK123456\nACGT")
    }

    func testNoTaxonWarns() {
        let r = FastaRenamerCore.rename(">MK123456.1 uncultured bacterium clone X1\nACGT")
        XCTAssertEqual(r.warnings.count, 1)
    }
}
