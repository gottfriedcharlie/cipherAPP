//
//  ContentView.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            cipherSelectView()
            //decipherView()
                .tabItem {
                    Label("Ciphers!", systemImage: "lock")
                }
            
            decipherView()
                .tabItem {
                    Label("Decipher!", systemImage: "lock.open")
                }
        }
    }
}

#Preview {
    ContentView()
}
