//
//  cipherSelectView.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/22/25.
//

import SwiftUI

enum sheetType: Identifiable {
    case ceasar
    case reverse
    case atbash
    case playfair
    case viginere
    case aes
    
    var id: Self { self }
}


struct cipherSelectView: View {
   
    //sets as nothing select till something is seleced
    @State var sheetOpen: sheetType?
    
    var body: some View {
        
        VStack {
            Text("Select a Cipher")
                .font(.largeTitle)
                .padding(.top, 3)
            Text("Select one of the following ciphers to encode text")
                .font(.caption)
            
            VStack(spacing: 16){
                
                //simple
                Button(action: {
                    sheetOpen = .ceasar
                }) {
                    Text("Ceasar")
                }
                .buttonStyle(BigButtonStyle(color: .green))
                
                Button(action: {
                    sheetOpen = .reverse
                }) {
                    Text("Reverse")
                }
                .buttonStyle(BigButtonStyle(color: .green))
                
                Button(action: {
                    sheetOpen = .atbash
                }) {
                    Text("Atbash")
                }
                .buttonStyle(BigButtonStyle(color: .green))
                
                //medium
                Button(action: {
                    sheetOpen = .playfair
                }) {
                    Text("Playfair")
                }
                .buttonStyle(BigButtonStyle(color: .orange))
                
                Button(action: {
                    sheetOpen = .viginere
                }) {
                    Text("Vigenère")
                }
                .buttonStyle(BigButtonStyle(color: .orange))
                
                Button(action: {
                    sheetOpen = .aes
                }) {
                    Text("AES-256")
                }
                .buttonStyle(BigButtonStyle(color: .red))
            }
            .padding(.top, 60)
            .padding(.horizontal, 22)
            .sheet(item: $sheetOpen) { sheet in
                switch sheet {
                    
                case .ceasar:
                    ceasarSheet()
                    
                case .reverse:
                    reverseSheet()
                    
                case .atbash:
                    atbashSheet()
                
                case .playfair:
                    playfairSheet()
                
                case .viginere:
                    vigenereSheet()
                    
                case .aes:
                    aesSheet()
                    
                    
                }
                
                
            
            }
            
            
            
        }
    }
    
}


//Button structure color defined at button
struct BigButtonStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(color.opacity(configuration.isPressed ? 0.7 : 0.95))
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.largeTitle)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


#Preview {
    cipherSelectView()
}
