//
//  Atbash.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/23/25.
//

struct AtbashEncode {
    
    static func encrypt(plainText: String) -> String {
        
        
        let chars = Array(plainText)
        
        
        //looping through each character getting its ascii value then setting it to the encrypted character
        //char in character out but new character out is ciphered on
        let encryptedChars = chars.map { char -> Character in
            guard let ascii = char.asciiValue else { return char }
            
            let isUpper = (65...90).contains(ascii)
            let isLower = (97...122).contains(ascii)
            
            guard isUpper || isLower else { return char }
            
            let base: UInt8 = isUpper ? 65 : 97
            
            //Calculate 0-25 index
            let originalIndex = ascii - base
            
            //ATBASH FORMULA: New Index = 25 - Original Index
            let newIndex = 25 - originalIndex
            
            let shiftedAscii = base + newIndex
            
            return Character(UnicodeScalar(shiftedAscii))
        }
        return String(encryptedChars)
    }
}
