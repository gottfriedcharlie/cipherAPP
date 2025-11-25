//
//  aesSheet.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/22/25.
//

import SwiftUI

struct aesSheet: View {
    //this environment variable allows the sheet to dismiss itself
    @Environment(\.dismiss) var dismiss
    
    //aes requires a password/key to work
    @State private var password: String = ""
    @State private var plaintext: String = ""
    
    //these control the result popups
    @State private var showResultSheet = false
    @State private var decryptSheet = false
    
    //holds the final result to show in the sheet
    @State private var resultText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                
                Text("Enter a Password (Required)")
                    .fontWeight(.bold)
                
                HStack{
                    Spacer()
                    //securefield is better for passwords but texteditor is fine for visibility
                    TextField("Password", text: $password)
                        .autocorrectionDisabled()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                
                Text("Enter the plaintext/ciphertext below")
                    .fontWeight(.bold)
                
                TextEditor(text: $plaintext)
                    .autocorrectionDisabled()
                    .frame(maxHeight: 350)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.5))
                    )
                    .foregroundColor(Color.gray)
                    .font(.custom("HelveticaNeue", size: 13))
                    //fix for ios 17 texteditor bug
                    .onChange(of: plaintext) { oldValue, newValue in
                        plaintext = newValue
                    }
                
                HStack {
                    //ENCRYPT BUTTON
                    Button(action: {
                        //encrypt using our new struct
                        resultText = aes256Encode.encrypt(plainText: plaintext, password: password)
                        showResultSheet = true
                    }) {
                        Text("Encrypt Text")
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title2)
                    .tint(.blue)
                    .disabled(password.isEmpty || plaintext.isEmpty) //disable if no password
                    
                    //DECRYPT BUTTON
                    Button(action: {
                        //decrypt using our new struct
                        resultText = aes256Encode.decrypt(encodedText: plaintext, password: password)
                        decryptSheet = true
                    })
                    {
                        Text("Decrypt Text")
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title2)
                    .tint(.blue)
                    .disabled(password.isEmpty || plaintext.isEmpty)
                }
                .padding()
                
            }
            .navigationTitle(Text("AES-256"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .padding()
            
            //result sheets
            .sheet(isPresented: $showResultSheet) {
                resultSheet(text: resultText, showResultSheet: $showResultSheet, function: true)
                    .presentationDetents([.fraction(0.85)])
            }
            
            .sheet(isPresented: $decryptSheet) {
                resultSheet(text: resultText, showResultSheet: $decryptSheet, function: false)
                    .presentationDetents([.fraction(0.85)])
            }
        }
    }
}

#Preview {
    aesSheet()
}
