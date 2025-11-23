//
//  RailFenceCracker.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/22/25.
//

import Foundation

struct RailFenceCracker {
    
    //this struct just holds the results of cracking so we can return rails + text + score together
    struct Result {
        let rails: Int
        let plaintext: String
        let score: Double
    }
    
    //this tries all rail counts and picks the one that looks the most like english
    static func crack(ciphertext: String, minRails: Int, maxRails: Int) -> Result {
        //default result, kinda empty until we find something better
        var bestResult = Result(rails: 0, plaintext: "", score: -1.0)
        
        //dont let max rails be bigger than text length or it breaks for short strings
        let effectiveMax = min(maxRails, ciphertext.count)
        
        //loop through all rails and see which one makes the most english looking output
        for rails in minRails...effectiveMax {
            let decoded = decrypt(ciphertext: ciphertext, rails: rails)
            let currentScore = scoreEnglishLikelihood(text: decoded)
            
            //store this decoded text only if score is higher than last time
            if currentScore > bestResult.score {
                bestResult = Result(rails: rails, plaintext: decoded, score: currentScore)
            }
        }
        
        return bestResult
    }
    
    //this decrypts rail fence using a known number of rails (not guessing here)
    static func decrypt(ciphertext: String, rails: Int) -> String {
        // 1 rail is basically no cipher so just return it
        guard rails > 1 else { return ciphertext }
        let n = ciphertext.count
        
        //this matrix tracks where letters "would go" when writing zig zag
        var matrix = Array(repeating: Array(repeating: false, count: n), count: rails)
        
        //go down then up then down etc on rails
        var row = 0
        var checkDown = false
        
        //mark spots in zig zag pattern (but dont fill in letters yet)
        for col in 0..<n {
            matrix[row][col] = true
            
            //flip direction when we hit top or bottom rail
            if row == 0 || row == rails - 1 {
                checkDown.toggle()
            }
            
            row += checkDown ? 1 : -1
        }
        
        //now we fill the zig zag pattern with the ciphertext letters (in order)
        var filledMatrix = Array(repeating: Array(repeating: Character(" "), count: n), count: rails)
        var index = 0
        let chars = Array(ciphertext)
        
        //fill row by row cause thats how ciphertext was generated
        for r in 0..<rails {
            for c in 0..<n {
                if matrix[r][c] && index < n {
                    filledMatrix[r][c] = chars[index]
                    index += 1
                }
            }
        }
        
        //now we read across the zig zag to recover the true plaintext
        var result = ""
        row = 0
        checkDown = false
        
        for c in 0..<n {
            result.append(filledMatrix[row][c])
            
            if row == 0 || row == rails - 1 {
                checkDown.toggle()
            }
            row += checkDown ? 1 : -1
        }
        
        return result
    }
    
    //this trys to guess if text looks like english by looking for common words and vowel stuff
    static func scoreEnglishLikelihood(text: String) -> Double {
        let lower = text.lowercased()
        var score = 0.0
        
        //list of super common english words, if these appear then probably real english
        let commonWords = ["the", "be", "to", "of", "and", "a", "in", "that", "have", "it", "is", "for", "not", "on", "with", "he", "as", "you", "do", "at"]
        
        // boost score whenever we find one of those words inside
        for word in commonWords {
            if lower.contains(word) {
                score += 10.0
            }
        }
        
        //vowels check, english has a decent amount of vowels, if too few, probably not english
        let vowels = "aeiou"
        let vowelCount = lower.filter { vowels.contains($0) }.count
        let vowelRatio = Double(vowelCount) / Double(text.count)
        
        //if vowel ratio is tiny, its prob garbage decrypt so punish score
        if vowelRatio < 0.2 {
            score -= 20.0
        }
        
        return score
    }
}
