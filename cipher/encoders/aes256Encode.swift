//
//  aes256Encode.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/25/25.
//

import Foundation
import CryptoKit
import CommonCrypto //required for pbkdf2 on older ios targets

struct aes256Encode {
    
    //encrypts plaintext using a user password
    static func encrypt(plainText: String, password: String) -> String {
        guard !plainText.isEmpty, !password.isEmpty else { return "" }
        
        //1. salt (32 bytes)
        let salt = generateRandomBytes(count: 32)
        
        //2. derive key using commoncrypto (works on all ios versions)
        let key = deriveKey(password: password, salt: salt)
        
        //3. encrypt using cryptokit
        guard let data = plainText.data(using: .utf8) else { return "" }
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            
            //4. combine salt + nonce + ciphertext + tag for storage
            if let combined = sealedBox.combined {
                let finalData = salt + combined
                return finalData.base64EncodedString()
            }
        } catch {
            print("Encryption error: \(error)")
        }
        return ""
    }
    
    //decrypts the base64 string
    static func decrypt(encodedText: String, password: String) -> String {
        guard let data = Data(base64Encoded: encodedText) else { return "Error: Invalid Base64" }
        
        //salt (32) + nonce (12) + tag (16) = 60 bytes minimum
        if data.count < 60 { return "Error: Data too short" }
        
        let salt = data.prefix(32)
        let sealedBoxData = data.dropFirst(32)
        
        let key = deriveKey(password: password, salt: salt)
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: sealedBoxData)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8) ?? "Error: UTF8 Decode Failure"
        } catch {
            return "Error: Decryption Failed (Wrong Password?)"
        }
    }
    
    //key derivation using commoncrypto (robust fallback for pkcs5 errors)
    private static func deriveKey(password: String, salt: Data) -> SymmetricKey {
        let passwordData = password.data(using: .utf8)!
        let keyLength = 32 //256-bit key
        
        var derivedBytes = Data(repeating: 0, count: keyLength)
        
        //using the c-api directly avoids the cryptokit version requirement
        //i ran into an error with pkcs5 so needed to add common crypto here
        derivedBytes.withUnsafeMutableBytes { keyBytes in
            passwordData.withUnsafeBytes { passBytes in
                salt.withUnsafeBytes { saltBytes in
                    CCKeyDerivationPBKDF(
                        CCPBKDFAlgorithm(kCCPBKDF2),                  //algorithm
                        passBytes.baseAddress, passwordData.count,    //password
                        saltBytes.baseAddress, salt.count,            //salt
                        CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256), //hash: sha256
                        100_000,                                      //rounds
                        keyBytes.baseAddress,                         //output buffer
                        keyLength                                     //output length
                    )
                }
            }
        }
        
        return SymmetricKey(data: derivedBytes)
    }
    
    private static func generateRandomBytes(count: Int) -> Data {
        var key = Data(count: count)
        let result = key.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, count, $0.baseAddress!)
        }
        return key
    }
}
