//
//  playfairCracker.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/25/25.
//
//coundnt figure out how to add key and dont have that much time to do it at the moment so all
//plaintext is ciphered with abcdefghiklmnopqrstuvwxyz
//so cracking is very easy just opposite of encoding
//or if user wants to decrypt with a key thats also possible just only from the Play Fair Cipher Page

import Foundation

struct playfairCracker {
    
    struct Result {
        let plaintext: String
        let score: Double
    }

    
    //this function decrypts text using an EXISTING matrix (key)
    //it is simply the reverse of the encryption rules
    static func decrypt(cipherText: String, matrix: [[Character]]) -> Result {
        
        //clean the input to remove spaces/newlines if any
        let cleanCipher = cipherText.filter { $0.isLetter }
        
        //ensure even length (Playfair always produces even length ciphertext)
        //if its odd just return an error result
        guard cleanCipher.count % 2 == 0 else {
            return Result(plaintext: "Error: Ciphertext length is odd.", score: -100.0)
        }
        
        var decryptedText = ""
        let chars = Array(cleanCipher)
        
        //process in pairs
        for i in stride(from: 0, to: chars.count, by: 2) {
            let char1 = chars[i]
            let char2 = chars[i+1]
            
            let pair = reversePlayFairRules(char1: char1, char2: char2, matrix: matrix)
            decryptedText.append(pair)
        }
        
        //calculate score for the decrypted text so we know if its good english
        let score = englishLike.scoreEnglishLikelihood(text: decryptedText)
        
        return Result(plaintext: decryptedText, score: score)
    }
    
    //this function applies the REVERSE rules of Playfair
    //1. Same Row -> Left (Wrap around)
    //2. Same Col -> Up (Wrap around)
    //3. Rectangle -> Swap Cols (Same as encryption)
    static func reversePlayFairRules(char1: Character, char2: Character, matrix: [[Character]]) -> String {
        
        guard let p1 = findPosition(of: char1, in: matrix),
              let p2 = findPosition(of: char2, in: matrix) else {
            return ""
        }
        
        var c1: Character
        var c2: Character
        
        if p1.row == p2.row {
            //rule 1: Same Row -> LEFT
            //(col - 1 + 5) % 5 handles the wrap around correctly for negative numbers
            c1 = matrix[p1.row][(p1.col - 1 + 5) % 5]
            c2 = matrix[p2.row][(p2.col - 1 + 5) % 5]
        } else if p1.col == p2.col {
            //rule 2: Same Col -> UP
            //(row - 1 + 5) % 5 handles wrap around
            c1 = matrix[(p1.row - 1 + 5) % 5][p1.col]
            c2 = matrix[(p2.row - 1 + 5) % 5][p2.col]
        } else {
            //rule 3: Rectangle -> Swap Cols (Same as encrypt)
            c1 = matrix[p1.row][p2.col]
            c2 = matrix[p2.row][p1.col]
        }
        
        return String(c1) + String(c2)
    }
    
    //helper to find coordinates
    static func findPosition(of char: Character, in matrix: [[Character]]) -> (row: Int, col: Int)? {
        for (rowIndex, row) in matrix.enumerated() {
            if let colIndex = row.firstIndex(of: char) {
                return (rowIndex, colIndex)
            }
        }
        return nil
    }
}
