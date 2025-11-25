//
//  playfairEncode.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/24/25.
//

import Foundation

struct playfairEncode {
    
    static func encrypt(plainText: String, keyWord: String) -> String {
        
        //get rid of J because playfair doesnt like J and replaces him with I
        let normalizedPlain = plainText
            .uppercased()
            .replacingOccurrences(of: "J", with: "I")
        
        let trimmedText = Array(normalizedPlain.filter { $0.isLetter })
        var cleanedText = ""
        var plaintextCount: Int = 0
        var dividors: Int = 0
        
        
        let matrix = createMatrix(keyWord: keyWord)
        print(matrix)
        
        
        //MARK: this prepares the plaintext for encoding
        //logic: We now check pairs as we go. If we find a double letter in the SAME pair, we add X and shift by 1.
        var i = 0
        while i < trimmedText.count {
            let char = trimmedText[i]
            cleanedText.append(char)
            
            //check if last character 
            if i + 1 < trimmedText.count {
                let nextChar = trimmedText[i+1]
                
                if char == nextChar {
                    //Double letter in the same pair ex LL
                    //insert X, and do NOT skip the second L yet, it becomes start of the next pair
                    cleanedText.append("X")
                    i += 1
                } else {
                    //normal append the second character
                    cleanedText.append(nextChar)
                    i += 2
                }
            } else {
                //last character is alone, pad with X
                cleanedText.append("X")
                i += 1
            }
        }
        
        plaintextCount = Array(cleanedText).count
        
        //maks sure plaintexts is even so we can split into pairs
        if !plaintextCount.isMultiple(of: 2) {
            cleanedText.append("X")
            plaintextCount += 1
        }
        
        dividors = plaintextCount / 2
        
        var cipherText: [String] = []
        let cleanedChars = Array(cleanedText)
        

        //index insures we grab pairs
        for i in 0..<dividors {
            let index = i * 2
            let first = cleanedChars[index]
            let second = cleanedChars[index + 1]
            
            let cipheredPair = playFairRules(char1: first, char2: second, matrix: matrix)
            cipherText.append(cipheredPair)
        }
        
        let encryptedtext = cipherText.joined()
        
        return encryptedtext
    }
    
    
    
    //this fucntion take the keywords and creates a 2d array with it and
    //the remaining character in the alpahabet hence why it returns a 2d array of characters
    static func createMatrix(keyWord: String) -> [[Character]] {
        let alphabet = "ABCDEFGHIKLMNOPQRSTUVWXYZ"
        
        let input = (keyWord.uppercased() + alphabet).replacingOccurrences(of: "J", with: "I")
        
        var uniqueChars: [Character] = []
        
        //does not store duplicates so a set is used
        var seenChars: Set<Character> = []
        
        for char in input {
            if char.isLetter  && !seenChars.contains(char) {
                uniqueChars.append(char)
                seenChars.insert(char)
            }
        }
        
        //create the 5 by 5 matrix to refer to
        var matrix = Array(repeating: Array(repeating: Character(" "), count: 5), count: 5)
        
        //index is used to make sure we get all aviable characters and to select the correct
        //character in uniqueChars
        var index = 0
        //rows
        for i in 0..<5 {
            //cols
            for j in 0..<5 {
                if index < uniqueChars.count {
                    matrix[i][j] = uniqueChars[index]
                    index += 1
                }
            }
        }
        return matrix
    }
    
    //this function will ask the rules to determine how the plaintext gets ciphered up
    //three rules
    //rule 1 is if they are in the same row, replace with Right element loop around to start
    //rule 2 if they are in the same column, replace with Below element loop around to top
    //rule 3 is if they are in neither, draw a rectange in the table and take the opposite corners
    static func playFairRules(char1: Character, char2: Character, matrix: [[Character]]) -> String {
        
        let char1Coordinates = findPosition(of: char1, in: matrix)
        let char2Coordinates = findPosition(of: char2, in: matrix)
        
        var cipherChar1 : Character
        var cipherChar2 : Character
        var encodedChars: String = ""
        //unwrapping making sure char1 and char2 are valid, stupid errors making me add this
        if let char1Coordinates = char1Coordinates,
           let char2Coordinates = char2Coordinates {
            
            
            //rule 1
            if char1Coordinates.row == char2Coordinates.row {
                cipherChar1 = matrix[char1Coordinates.row][(char1Coordinates.col + 1) % 5]
                cipherChar2 = matrix[char2Coordinates.row][(char2Coordinates.col + 1) % 5]
            }
            
            //rule 2
            else if char1Coordinates.col == char2Coordinates.col {
                cipherChar1 = matrix[(char1Coordinates.row + 1) % 5][char1Coordinates.col]
                cipherChar2 = matrix[(char2Coordinates.row + 1) % 5][char2Coordinates.col]
            }
            
            //rule 3
            else {
                cipherChar1 = matrix[char1Coordinates.row][char2Coordinates.col]
                cipherChar2 = matrix[char2Coordinates.row][char1Coordinates.col]
            }
            
            
            encodedChars.append(cipherChar1)
            encodedChars.append(cipherChar2)
        }
        return encodedChars
    }
    
    
    
    
    //static because its just a simple helper function for this struct
    //this function find the position of the character both row and col
    static func findPosition(of char: Character, in matrix: [[Character]]) -> (row: Int, col: Int)? {
        for (rowIndex, row) in matrix.enumerated() {
            if let colIndex = row.firstIndex(of: char) {
                return (rowIndex, colIndex)
            }
        }
        return nil
    }
    
    
}
