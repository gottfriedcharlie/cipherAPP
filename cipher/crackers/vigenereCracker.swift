//
//  vigenereCracker.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/25/25.
//code is just basically copied from my vigenere cracker on my git in c++

import Foundation

struct vigenereCracker {
    
    //MOVED: Result struct is now nested to avoid conflict with other files
    struct Result {
        let key: String
        let plaintext: String
        let score: Double
    }

    
    //english letter frequencies matching the c++ code
    static let englishFreqs: [Double] = [
        0.08167, 0.01492, 0.02782, 0.04253, 0.12702, 0.02228, 0.02015, 0.06094, 0.06966,
        0.00153, 0.00772, 0.04025, 0.02406, 0.06749, 0.07507, 0.01929, 0.00095, 0.05987,
        0.06327, 0.09056, 0.02758, 0.00978, 0.02360, 0.00150, 0.01974, 0.00074
    ]
    
    //main cracking function
    static func crack(ciphertext: String, minKeyLength: Int = 1, maxKeyLength: Int = 20) -> Result {
        
        //clean input like the prepText function in c++
        let cleanText = ciphertext.filter { $0.isLetter }.uppercased()
        let n = cleanText.count
        
        //safety check
        if n == 0 { return Result(key: "", plaintext: "", score: 0.0) }
        
        let effectiveMax = min(maxKeyLength, n)
        
        //ioc for all possible lengths
        var candidates: [(len: Int, ioc: Double)] = []
        for k in minKeyLength...effectiveMax {
            let currentIoC = calculateAverageIoC(text: cleanText, keyLength: k)
            candidates.append((len: k, ioc: currentIoC))
        }
        
        //sort the key canidates
        let sortedCandidates = candidates.sorted { $0.ioc > $1.ioc }
        
        //select the best canidate
        guard let bestCandidate = sortedCandidates.first else {
            return Result(key: "", plaintext: "", score: 0.0)
        }
        
        //gets the best key length so catcatcat is just cat
        var finalKeyLength = bestCandidate.len
        
        let factors = (1...bestCandidate.len).filter { bestCandidate.len % $0 == 0 && $0 < bestCandidate.len }
        
        for factor in factors {
            //find the score for this factor
            if let factorScore = candidates.first(where: { $0.len == factor })?.ioc {
                // If factor score is acceptable (close to English IoC 0.067), PREFER THE FACTOR
                // 0.055 is a safe lower bound for "probably English"
                if factorScore > 0.055 {
                    finalKeyLength = factor
                    break //found it
                }
            }
        }
        
        // 5. Solve for the final chosen length
        let key = solveKey(text: cleanText, keyLength: finalKeyLength)
        let plaintext = decrypt(ciphertext: cleanText, key: key)
        let score = englishLike.scoreEnglishLikelihood(text: plaintext)
        
        return Result(key: key, plaintext: plaintext, score: score)
    }
    
    //decrypts text with a keyword
    static func decrypt(ciphertext: String, key: String) -> String {
        let textChars = Array(ciphertext)
        let keyChars = Array(key)
        var keyWordResult = ""
        
        for i in 0..<textChars.count {
            let c = textChars[i]
            let k = keyChars[i % keyChars.count]
            
            //math: (cipher - key + 26) % 26
            //using ascii values where A=0
            let cVal = Int(c.asciiValue!) - 65
            let kVal = Int(k.asciiValue!) - 65
            
            let pVal = (cVal - kVal + 26) % 26
            let pChar = Character(UnicodeScalar(pVal + 65)!)
            
            keyWordResult.append(pChar)
        }
        
        return keyWordResult
    }
    
    //calculates average ioc for a specific key length (KIoc in c++)
    static func calculateAverageIoC(text: String, keyLength: Int) -> Double {
        let columns = getColumns(text: text, keyLength: keyLength)
        var sum = 0.0
        
        for col in columns {
            sum += calculateIoC(text: col)
        }
        
        return sum / Double(keyLength)
    }
    
    //calculates ioc of a single string (avgIoC in c++)
    static func calculateIoC(text: String) -> Double {
        var counts = Array(repeating: 0, count: 26)
        var n = 0
        
        for char in text {
            let idx = Int(char.asciiValue!) - 65
            if idx >= 0 && idx < 26 {
                counts[idx] += 1
                n += 1
            }
        }
        
        if n < 2 { return 0.0 }
        
        var num = 0.0
        for count in counts {
            num += Double(count * (count - 1))
        }
        
        return num / Double(n * (n - 1))
    }
    
    //solves for the best key for a given length using chi-square
    static func solveKey(text: String, keyLength: Int) -> String {
        let columns = getColumns(text: text, keyLength: keyLength)
        var key = ""
        
        for col in columns {
            let bestShift = bestChiShift(column: col)
            let keyChar = Character(UnicodeScalar(bestShift + 65)!)
            key.append(keyChar)
        }
        
        return key
    }
    
    //finds the shift that produces the lowest chi-square score (bestChiShift in c++)
    static func bestChiShift(column: String) -> Int {
        var minChi = Double.greatestFiniteMagnitude
        var bestShift = 0
        
        for shift in 0..<26 {
            let chi = calculateChiSquare(column: column, shift: shift)
            if chi < minChi {
                minChi = chi
                bestShift = shift
            }
        }
        
        return bestShift
    }
    
    //calculates chi-square for a specific shift (chiSquareShift in c++)
    static func calculateChiSquare(column: String, shift: Int) -> Double {
        let n = column.count
        if n == 0 { return Double.greatestFiniteMagnitude }
        
        var counts = Array(repeating: 0, count: 26)
        
        //unshift text and count frequencies
        for char in column {
            let cipherVal = Int(char.asciiValue!) - 65
            let plainVal = (cipherVal - shift + 26) % 26
            counts[plainVal] += 1
        }
        
        var chi = 0.0
        for i in 0..<26 {
            let expected = Double(n) * englishFreqs[i]
            if expected > 1e-12 {
                let diff = Double(counts[i]) - expected
                chi += (diff * diff) / expected
            }
        }
        
        return chi
    }
    
    //splits text into k columns (coloumns in c++)
    static func getColumns(text: String, keyLength: Int) -> [String] {
        var cols = Array(repeating: "", count: keyLength)
        let chars = Array(text)
        
        for i in 0..<chars.count {
            cols[i % keyLength].append(chars[i])
        }
        
        return cols
    }
}
