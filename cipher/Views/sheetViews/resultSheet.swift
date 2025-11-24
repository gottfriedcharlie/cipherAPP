//
//  resultSheet.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/23/25.
//

import SwiftUI

struct resultSheet: View {
    
    let cipherText: String
    
    @Binding var showResultSheet: Bool
    
    @State private var isCopied = false
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Encryption Result")
                    .font(.headline)
                
                Button(action: {
                    
                    UIPasteboard.general.string = cipherText
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
            
            Text(cipherText)
                .foregroundColor(.gray)
                .padding()
            
            Spacer()
        }
    }
}

