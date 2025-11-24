//
//  reverseSheet.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/22/25.
//

import SwiftUI

struct reverseSheet: View {
    // This environment variable allows the sheet to dismiss itself
    @Environment(\.dismiss) var dismiss
    @State private var plaintext = " "
    @State private var ciphertext = " "
    
    
    @State private var showResultSheet = false
    
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                Text("Enter the text to be reveresed below")
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
                    
                    ciphertext = reverseEncode.encrypt(plainText: plaintext)
                    
                    showResultSheet = true
                }) {
                    Text("Encrpt Text")
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
                .tint(.blue)
            }
            .padding()
            .navigationTitle(Text("Reverse Cipher"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close"){
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
    reverseSheet()
}
