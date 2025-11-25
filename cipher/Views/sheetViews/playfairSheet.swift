//
//  playfairSheet.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/22/25.
//

import SwiftUI

struct playfairSheet: View {
    //This environment variable allows the sheet to dismiss itself
    @Environment(\.dismiss) var dismiss
    @State private var key: String = " "
    @State private var plaintext: String = " "
    @State private var ciphertext: String = " "
    
    //controls ceasar sheet
    @State private var showResultSheet = false
    @State private var decryptSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                
                Text("Enter A keyword Below Ex: Playfair")
                    .fontWeight(.bold)
                
                HStack{
                    Spacer()
                    TextEditor(text: $key)
                        .autocorrectionDisabled()
                    //Text("KeyWord encryption is not built in, Coming soon")
                        .frame(maxHeight: 50)
                        .frame(maxWidth: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.5))
                        )
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.3)
                    Spacer()
                }
                
                Text("Enter the plaintext/ciphertext below")
                    .fontWeight(.bold)
                Text("For propper encrytion it will clean the text. Example: Play: Fair -> playfair")
                    .font(.caption)
                
                TextEditor(text: $plaintext)
                    .autocorrectionDisabled()
                    .frame(maxHeight: 350)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.5))
                    )
                    .foregroundColor(Color.gray)
                    .font(.custom("HelveticaNeue", size: 13))
                    .onChange(of: plaintext) { oldValue, newValue in
                        plaintext = newValue
                    }
                
                HStack {
                    //this button updates to show result sheet
                    Button(action: {
                        let keyWord = String(key).uppercased().filter { $0.isLetter }
                        
                        ciphertext = playfairEncode.encrypt(plainText: plaintext, keyWord: keyWord)
                        
                        
                        
                        
                        showResultSheet = true
                    }) {
                        Text("Encrpt Text")
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title2)
                    .tint(.blue)
                    
                    Button(action: {
                        var playFair = playfairCracker.decrypt(cipherText: plaintext, matrix: playfairEncode.createMatrix(keyWord: key))
                        plaintext = playFair.plaintext
                        decryptSheet = true
                    })
                    {
                        Text("Decrypt Text")
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title2)
                    .tint(.blue)
                }
                .padding()
                
            }
            .navigationTitle(Text("Play Fair Cipher"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .padding()
            // 3. Attach the sheet modifier here
            .sheet(isPresented: $showResultSheet) {
                // This is the content of the pop-up sheet
                resultSheet(text: ciphertext, showResultSheet: $showResultSheet, function: true)
                    .presentationDetents([.fraction(0.85)])
            }
            
            .sheet(isPresented: $decryptSheet) {
                resultSheet(text: plaintext, showResultSheet: $decryptSheet, function: false)
                    .presentationDetents([.fraction(0.85)])
            }
        }
    }
}

#Preview {
    playfairSheet()
}
