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

    var body: some View {
        VStack(spacing: 20) {
            Text("atbashSheet")
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
    atbashSheet()
}
