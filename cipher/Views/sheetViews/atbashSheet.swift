//
//  atbashSheet.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/22/25.
//

import SwiftUI

struct atbashSheet: View {
    // This environment variable allows the sheet to dismiss itself
    @Environment(\.dismiss) var dismiss
    @State private var plaintext: String = ""
    @State private var ciphertext: String = ""
    
    @State private var showResultSheet = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                Text("Enter the text to be cipher with the Atbash method")
                    .fontWeight(.bold)
                
                TextEditor(text: $plaintext)
                    .frame(maxHeight: 450)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.5))
                    )
                    .foregroundColor(Color.gray)
                    .font(.custom("HelveticaNeue", size: 13))
                    .onChange(of: plaintext) { oldValue, newValue in
                            plaintext = newValue
                        }
                
                Button(action: {
                    ciphertext = AtbashEncode.encrypt(plainText: plaintext)
                    
                    showResultSheet = true
                }) {
                    Text("Encrypt Text")
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
                .tint(.blue)
            }
            .padding()
            .navigationTitle(Text("Atbash Cipher"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showResultSheet) {
                // This is the content of the pop-up sheet
                resultSheet(cipherText: ciphertext, showResultSheet: $showResultSheet)
                    .presentationDetents([.fraction(0.85)])
                
            }
            
            
            
            
            
        }
        
    }
}



#Preview {
    atbashSheet()
}
