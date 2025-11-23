//
//  ceasarCracker.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/23/25.
//

import Foundation

struct caesarCracker {
    
    struct Result {
        let shift: Int
        let plaintext: String
        let score: Double
    }
    
    //brute forces by trying all shifts
    static func crack(ciphertext: String) -> Result {
        var bestResult = Result(shift: 0, plaintext: "", score: -1000.0)
        
        //try every possible shift (0 to 25)
        for shift in 0..<26 {
            //if text was shifted by +3, we shift by -3 (or +23) to fix it
            let candidateText = decrypt(text: ciphertext, shift: shift)
            let score = englishLike.scoreEnglishLikelihood(text: candidateText)
            
            if score > bestResult.score {
                bestResult = Result(shift: shift, plaintext: candidateText, score: score)
            }
        }
        
        return bestResult
    }
    
    //this trys decrypting the text with each shift attempted
    private static func decrypt(text: String, shift: Int) -> String {
        //to reverse a shift of N, we simply shift by (26 - N)
        //Example: If shifted forward by 1 (A->B), we shift forward by 25 to loop back (B->A)
        let reverseShift = (26 - (shift % 26)) % 26
        
        //just opposite of what we did in ceasear encrypt
        return text.map { char -> Character in
            guard let ascii = char.asciiValue else { return char }
            let isUpper = (65...90).contains(ascii)
            let isLower = (97...122).contains(ascii)
            guard isUpper || isLower else { return char }
            
            let base: UInt8 = isUpper ? 65 : 97
            let shifted = base + (ascii - base + UInt8(reverseShift)) % 26
            return Character(UnicodeScalar(shifted))
        }.reduce("") { String($0) + String($1) }
    }
    
}
