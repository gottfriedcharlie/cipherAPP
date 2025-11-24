//
//  reverseEncode.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/23/25.
//

struct reverseEncode {
    
    static func encrypt(plainText: String) -> String {
        
        let chars = Array(plainText)
        
        let encryptedChars = chars.reversed()
        
        return String(encryptedChars)
    }
}
