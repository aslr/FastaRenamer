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
}
