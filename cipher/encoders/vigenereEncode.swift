//
//  vigenereEncode.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/25/25.
//

import Foundation

struct vigenereEncode {
    
    static func encrypt(plainText: String, key: String) -> String {
        
        //clean input (remove spaces, non-letters) similar to the c++ loop
        let cleanText = plainText.filter { $0.isLetter }.uppercased()
        let cleanKey = key.filter { $0.isLetter }.uppercased()
        
        //safety check to avoid crash on empty key
        guard !cleanKey.isEmpty else { return plainText }
        
        var cipherText = ""
        let keyChars = Array(cleanKey)
        var counter = 0
        
        for char in cleanText {
            //get ascii value (A=0, B=1, etc.)
            //force unwrap is safe because we filtered for letters
            let plainVal = Int(char.asciiValue!) - 65
            let keyVal = Int(keyChars[counter].asciiValue!) - 65
            
            //advance key counter and loop around
            counter = (counter + 1) % keyChars.count
            
            //math: (plain + key) % 26
            let cipherVal = (plainVal + keyVal) % 26
            
            //convert back to character
            let cipherChar = Character(UnicodeScalar(cipherVal + 65)!)
            cipherText.append(cipherChar)
        }
        
        return cipherText
    }
    
    static func decrypt(cipherText: String, key: String) -> String {
        
        //clean input
        let cleanCipher = cipherText.filter { $0.isLetter }.uppercased()
        let cleanKey = key.filter { $0.isLetter }.uppercased()
        
        guard !cleanKey.isEmpty else { return cipherText }
        
        var plainText = ""
        let keyChars = Array(cleanKey)
        var counter = 0
        
        for char in cleanCipher {
            let cipherVal = Int(char.asciiValue!) - 65
            let keyVal = Int(keyChars[counter].asciiValue!) - 65
            
            counter = (counter + 1) % keyChars.count
            
            //math: (cipher - key + 26) % 26
            //adding 26 ensures we don't get negative numbers before the modulo
            let plainVal = (cipherVal - keyVal + 26) % 26
            
            let plainChar = Character(UnicodeScalar(plainVal + 65)!)
            plainText.append(plainChar)
        }
        
        return plainText
    }
}
