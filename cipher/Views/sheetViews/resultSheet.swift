//
//  resultSheet.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/23/25.
//

import SwiftUI

struct resultSheet: View {
    
    let text: String
    
    @Binding var showResultSheet: Bool
    
    @State private var isCopied = false
    
    var function: Bool
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                let heading = function ? "Encryption Result" : "Decryption Result"
                Text(heading)
                    .font(.headline)
                
                Button(action: {
                    
                    UIPasteboard.general.string = text
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
            
            Text(text)
                .foregroundColor(.gray)
                .padding()
            
            Spacer()
        }
    }
}

