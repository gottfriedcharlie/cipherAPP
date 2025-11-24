//
//  reverseCracker.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/23/25.
//

struct reverseCracker {
    
    struct Result {
        let plaintext: String
        let score: Double
    }
    
    static func crack(cipherText: String) -> Result {
        
        var bestResult = Result(plaintext: "", score: -1000.0)
        
        let chars = Array(cipherText)
        
        let candidateText = chars.reversed()
        
        let score = englishLike.scoreEnglishLikelihood(text: String(candidateText))
        bestResult = Result(plaintext: String(candidateText), score: score)
        
        return bestResult
    }
}
