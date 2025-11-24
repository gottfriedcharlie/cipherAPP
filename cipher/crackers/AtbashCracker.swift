//
//  AtbashCracker.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/23/25.
//

struct AtbashCracker {
    
    struct Result {
        let plaintext: String
        let score: Double
    }
    
    static func crack(cipherText: String) -> Result {
        var bestResult = Result(plaintext: "", score: -1000.0)
        
        
        //we Atbash we can just use encoder because it is the same as decoding
        let candidateText = AtbashEncode.encrypt(plainText: cipherText)
        
        
        let score = englishLike.scoreEnglishLikelihood(text: String(candidateText))
        bestResult = Result(plaintext: String(candidateText), score: score)
        
        
        
        
        return bestResult
    }
    
    
}
