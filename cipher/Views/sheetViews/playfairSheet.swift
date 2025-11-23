//
//  ceasarSheet.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/22/25.
//

import SwiftUI

struct playfairSheet: View {
    // This environment variable allows the sheet to dismiss itself
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("playfairSheet")
                .font(.title)
            
            Button("Close") {
                dismiss()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    playfairSheet()
}
