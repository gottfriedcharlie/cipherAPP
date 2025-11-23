//
//  ceasarEncode.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/22/25.
//


struct ceasarEncode {
    
    static func encrypt(shift: Int, plainText: String) -> String {
        
        //if shift over 26 it mods
        let shift = ((shift % 26) + 26) % 26
        
        let chars = Array(plainText)
        //map is a loop which all the code in the brackets will be run on each the text chars
        //char -> Character in means taking in a char and returning a char
        let encryptedChars = chars.map { char -> Character in
            //gets ascii value and if not an a value aA - zZ just return the char
            guard let ascii = char.asciiValue else { return char }
            
            
            //checking if the current char is upper or lower
            let isUpper = (65...90).contains(ascii)
            let isLower = (97...122).contains(ascii)
            
            guard isUpper || isLower else { return char }
            
            
            //let base which is a Uint = to 65 if upper 97 if lower
            let base: UInt8 = isUpper ? 65 : 97
            
            //(plaintext - base + shift) % 26 + base
            //adding the 26 before because of negative shifts
            let shiftedAscii = base + (ascii - base + UInt8(shift) + 26 ) % 26
            
            
            //this is needed to return the correct char as it checks if the value is valid before 
            return Character(UnicodeScalar(shiftedAscii))
            
            
        }
        return String(encryptedChars)
    }
    
}
