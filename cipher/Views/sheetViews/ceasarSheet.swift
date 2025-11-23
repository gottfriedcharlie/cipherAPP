//
//  ceasarSheet.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/22/25.
//

import SwiftUI

struct ceasarSheet: View {
    //This environment variable allows the sheet to dismiss itself
    @Environment(\.dismiss) var dismiss
    @State private var key: String = " "
    @State private var plaintext: String = " "
    @State private var isCopied: Bool = false
    
    //controls ceasar sheet
    @State private var showResultSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                
                Text("Enter A key below: ex. 3")
                    .fontWeight(.bold)
                
                HStack{
                    Spacer()
                    TextEditor(text: $key)
                        .frame(maxHeight: 50)
                        .frame(maxWidth: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.5))
                        )
                    
                    Button(action: {
                        // save key to encode
                    }) {
                        Text("Save")
                    }
                    Spacer()
                }
                
                Text("Enter the plaintext below")
                    .fontWeight(.bold)
                
                TextEditor(text: $plaintext)
                    .frame(maxHeight: 250)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.5))
                    )
                    .foregroundColor(Color.gray)
                    .font(.custom("HelveticaNeue", size: 13))
                
                //this button updates to show result sheet
                Button(action: {
                    showResultSheet = true
                }) {
                    Text("Encrpt Text")
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
                .tint(.blue)
                
                Spacer()
                
            }
            .navigationTitle(Text("Ceasar Cipher"))
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
                VStack(spacing: 20) {
                    HStack {
                        Text("Encryption Result")
                            .font(.headline)
                        
                        Button(action: {
                            isCopied = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isCopied = false
                            }
                        } ) {
                            Label(isCopied ? "Copied!" : "Copy", systemImage: isCopied ? "checkmark" : "doc.on.doc")
                        }
                        .buttonStyle(.bordered)
                        
                        
                        Button("Done") {
                            showResultSheet = false
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.top, 15)
                    
                    Spacer()
                    
                    Text("Your encrypted text will appear here.")
                        .foregroundColor(.gray)
                        .padding()
                    
                    Spacer()
                }
                // Optional: Makes it a half-sheet (pop-up style)
                .presentationDetents([.fraction(0.85)])
            }
        }
    }
}

#Preview {
    ceasarSheet()
}
