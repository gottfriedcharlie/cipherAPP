//
//  decipherView.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/22/25.
//

import SwiftUI

struct decipherView: View {
    @State private var cipherText: String = ""
    @State private var errorMessage: String = ""
    
    @State private var results: [CipherCrackResult] = []
    @State private var showResults: Bool = false
    @State private var hasCracked: Bool = false   // controls button color
    
    struct CipherCrackResult: Identifiable {
        let id = UUID()
        let name: String          // which cipher
        let plaintext: String     // decoded text
        let details: String       // extra info (rails, score, etc.)
        let score: Double         // higher = better / more English
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Auto Cipher Cracker")
                    .font(.title2)
                    .bold()
                
                Text("Ciphertext")
                    .font(.headline)
                
                TextEditor(text: $cipherText)
                    .frame(minHeight: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.5))
                    )
                    .padding(.bottom, 4)
                    .onChange(of: cipherText) { oldValue, newValue in
                        // if user edits text, button goes back to blue
                        hasCracked = false
                    }
                
                Button(hasCracked ? "Cracked ✓ (View Results)" : "Crack All Ciphers") {
                    runAllCrackers()
                }
                .buttonStyle(.borderedProminent)
                .tint(hasCracked ? .green : .blue)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Decipher")
            .sheet(isPresented: $showResults) {
                ResultsView(results: results)
            }
        }
    }
    
    // tries all cipher crackers we have and stores results
    private func runAllCrackers() {
        let trimmed = cipherText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter some ciphertext first."
            results = []
            hasCracked = false
            showResults = false
            return
        }
        
        errorMessage = ""
        
        var newResults: [CipherCrackResult] = []
        
        //ceasar cracker
        let caesar = caesarCracker.crack(ciphertext: trimmed)
        newResults.append(
            CipherCrackResult(
                name: "Caesar",
                plaintext: caesar.plaintext,
                details: "shift: \(caesar.shift), score: \(Int(caesar.score))",
                score: caesar.score
            )
        )
        
        //reverse cracker
        let reverse = reverseCracker.crack(cipherText: trimmed)
        newResults.append(
            CipherCrackResult(
                name: "Reverse",
                plaintext: reverse.plaintext,
                details: "score: \(Int(reverse.score))",
                score: reverse.score
            )
        )
        
        //at bash cracker
        let atBash = AtbashCracker.crack(cipherText: trimmed)
        newResults.append(
            CipherCrackResult(
                name: "atBash",
                plaintext: atBash.plaintext,
                details: "score: \(Int(atBash.score))",
                score: atBash.score
            )
        )
        
        //rail fence cracker
        let rf = RailFenceCracker.crack(ciphertext: trimmed, minRails: 2, maxRails: 10)
        newResults.append(
            CipherCrackResult(
                name: "Rail Fence",
                plaintext: rf.plaintext,
                details: "rails: \(rf.rails), score: \(Int(rf.score))",
                score: rf.score
            )
        )
        
        //playfair cracker
        let playFair = playfairCracker.decrypt(cipherText: trimmed, matrix: playfairEncode.createMatrix(keyWord: ""))

        newResults.append(
            CipherCrackResult(
                name: "Playfair",
                plaintext: playFair.plaintext,
                details: "Standard Key, score: \(Int(playFair.score))",
                score: playFair.score
                
            )
        )
        
        
        //vigenere cracker
        let vigenere = vigenereCracker.crack(ciphertext: trimmed)
        newResults.append(
            CipherCrackResult(
                name: "Vigenère",
                plaintext: vigenere.plaintext,
                details: "key: \(vigenere.key), score: \(Int(vigenere.score))",
                score: vigenere.score
            )
        )
        
        
        
        // sort best to worst
        results = newResults.sorted { $0.score > $1.score }
        
        if results.isEmpty {
            hasCracked = false
            showResults = false
            errorMessage = "No results found."
        } else {
            hasCracked = true          // turn button green
            showResults = true         // pop up results sheet
        }
    }
}

// separate view for results sheet
struct ResultsView: View {
    let results: [decipherView.CipherCrackResult]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                if let best = results.first {
                    // Use HStack to align Text and Button
                    HStack {
                        Text("Best Guess: \(best.name)")
                            .font(.headline)
                        
                        Spacer() // Pushes button to the right
                        
                        Button(action: {
                            UIPasteboard.general.string = best.plaintext
                        }) {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if !best.details.isEmpty {
                        Text(best.details)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    ScrollView {
                        Text(best.plaintext)
                            .font(.body)
                            .padding(.top, 4)
                            .textSelection(.enabled) // allow standard selection
                    }
                    .frame(maxHeight: 200)
                }
                
                Divider()
                
                Text("All Attempts")
                    .font(.headline)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(results) { result in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(result.name)
                                    .font(.subheadline)
                                    .bold()
                                
                                if !result.details.isEmpty {
                                    Text(result.details)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Text(result.plaintext)
                                    .font(.caption)
                                    .lineLimit(4)
                                    .textSelection(.enabled) // allow selection here too
                            }
                            .padding(8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            // add context menu for quick copy
                            .contextMenu {
                                Button {
                                    UIPasteboard.general.string = result.plaintext
                                } label: {
                                    Label("Copy Text", systemImage: "doc.on.doc")
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    decipherView()
}
