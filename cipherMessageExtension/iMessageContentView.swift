//
//  iMessageContentView.swift
//  cipherMessageExtension
//
//  Created by Charlie Gottfried on 11/25/25.
//

import SwiftUI

struct iMessageContentView: View {
    //callback to tell the controller to send the message
    var onSend: (_ text: String, _ caption: String, _ cipherType: String) -> Void
    
    @State private var selectedCipher = CipherType.caesar
    @State private var inputText = ""
    @State private var keyText = ""
    @State private var outputText = ""
    
    //if we opened a message this will hold the data
    var initialData: (text: String, cipher: String)?
    
    enum CipherType: String, CaseIterable, Identifiable {
        case caesar = "Caesar"
        case atbash = "Atbash"
        case railFence = "Rail Fence"
        case playfair = "Playfair"
        case vigenere = "Vigenère"
        case reverse = "Reverse"
        case aes256 = "AES-256"
        
        var id: String { self.rawValue }
        
        //helper to know if we need to show the key field
        var requiresKey: Bool {
            switch self {
            case .atbash, .reverse: return false
            default: return true
            }
        }
        
        //helper to know which keyboard to show
        var keyIsNumeric: Bool {
            switch self {
            case .caesar, .railFence: return true
            default: return false
            }
        }
        
        //placeholder text for the key field
        var placeholder: String {
            switch self {
            case .caesar: return "Shift (Int)"
            case .railFence: return "Rails (Int)"
            case .playfair, .vigenere: return "Keyword"
            case .aes256: return "Password"
            default: return ""
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            //top header with picker
            HStack {
                Text("Cipher Messenger")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
                Picker("Cipher", selection: $selectedCipher) {
                    ForEach(CipherType.allCases) { cipher in
                        Text(cipher.rawValue).tag(cipher)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(.horizontal)
            
            //input fields
            VStack(spacing: 8) {
                TextField("Enter message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if selectedCipher.requiresKey {
                    TextField(selectedCipher.placeholder, text: $keyText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //if numeric key needed use number pad
                    #if !os(macOS)
                        .keyboardType(selectedCipher.keyIsNumeric ? .numberPad : .default)
                    #endif
                }
            }
            .padding(.horizontal)
            
            //action buttons
            HStack(spacing: 20) {
                Button(action: { performCipher(encrypt: true) }) {
                    Label("Encrypt", systemImage: "lock")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: { performCipher(encrypt: false) }) {
                    Label("Decrypt", systemImage: "lock.open")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            
            //output area appears only if there is a result
            if !outputText.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Result:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(outputText)
                        .font(.system(.body, design: .monospaced))
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .onTapGesture {
                            //copy on tap
                            UIPasteboard.general.string = outputText
                        }
                    
                    Button(action: {
                        //send the result back to imessage
                        onSend(outputText, "\(selectedCipher.rawValue) Message", selectedCipher.rawValue)
                    }) {
                        Text("Insert into Message")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.top)
        .onAppear {
            //if we opened a message load the data
            if let initial = initialData {
                inputText = initial.text
                if let type = CipherType(rawValue: initial.cipher) {
                    selectedCipher = type
                }
            }
        }
    }
    
    //this function bridges the ui to your existing cipher files
    //make sure those files are added to the extension target membership!
    func performCipher(encrypt: Bool) {
        let text = inputText
        let key = keyText
        var result = ""
        
        switch selectedCipher {
        case .caesar:
             if let shift = Int(key) {
                 let ceasarCracked = caesarCracker.crack(ciphertext: text)
                 result = encrypt ? ceasarEncode.encrypt(shift: shift, plainText: text) : ceasarEncode.decrypt(shift: shift, cipherText: text)
             } else { result = "Invalid Shift" }
            
        case .railFence:
            if let rails = Int(key) {
                if encrypt {
                    result = railfenceEncode.encrypt(plainText: text, rails: rails)
                } else {
                    //using the cracker decrypt since we know the rails
                    result = RailFenceCracker.decrypt(ciphertext: text, rails: rails)
                }
            } else { result = "Invalid Rails" }
            
        case .atbash:
            let atbashCracked = AtbashCracker.crack(cipherText: text)
            result = encrypt ? AtbashEncode.encrypt(plainText: text) : atbashCracked.plaintext
            
        case .playfair:
            if encrypt {
                result = playfairEncode.encrypt(plainText: text, keyWord: key)
            } else {
                //decrypt requires matrix creation
                let matrix = playfairEncode.createMatrix(keyWord: key)
                let res = playfairCracker.decrypt(cipherText: text, matrix: matrix)
                result = res.plaintext
            }
            
        case .vigenere:
            if encrypt {
                result = vigenereEncode.encrypt(plainText: text, key: key)
            } else {
                result = vigenereEncode.decrypt(cipherText: text, key: key)
            }
            
        case .reverse:
            //reverse is its own inverse
            result = String(text.reversed())
            
        case .aes256:
            if encrypt {
                result = aes256Encode.encrypt(plainText: text, password: key)
            } else {
                result = aes256Encode.decrypt(encodedText: text, password: key)
            }
        }
        
        outputText = result
    }
}
