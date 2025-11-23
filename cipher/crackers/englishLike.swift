//
//  englishLike.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/23/25.
//

struct englishLike {
    
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
