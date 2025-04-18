//
//  ContentView.swift
//  SpellingBee
//
//  Created by Aaron Medina on 3/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var centerLetter: Character = "T"
    @State private var outerLetters: [Character] = ["A", "C", "I", "P", "R", "S"]
    @State private var inputWord: String = ""
    @State private var submittedWords: [String] = []
    @State private var score: Int = 0
    @State private var showInvalidWordAlert = false
    @State private var invalidWordReason = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with score
            HStack {
                Text("Score: \(score)")
                    .font(.headline)
                Spacer()
                Button("New Game") {
                    resetGame()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            
            // Input field
            HStack {
                Text(inputWord)
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Button(action: {
                    deleteLastCharacter()
                }) {
                    Image(systemName: "delete.left")
                        .font(.title)
                }
                .disabled(inputWord.isEmpty)
            }
            .padding(.horizontal)
            
            // Action buttons
            HStack(spacing: 30) {
                Button("Shuffle") {
                    shuffleOuterLetters()
                }
                .buttonStyle(.bordered)
                
                Button("Enter") {
                    submitWord()
                }
                .buttonStyle(.borderedProminent)
                .disabled(inputWord.count < 4)
            }
            .padding(.bottom)
            
            // Honeycomb layout
            ZStack {
                // Center letter
                HexagonView(letter: String(centerLetter), isCenter: true)
                    .onTapGesture {
                        inputWord.append(centerLetter)
                    }
                
                // Outer letters arranged in a circle
                ForEach(0..<6) { index in
                    let angle = Double(index) * (360.0 / 6.0)
                    let radian = angle * .pi / 180
                    let x = cos(radian) * 68
                    let y = sin(radian) * 68
                    
                    HexagonView(letter: String(outerLetters[index]), isCenter: false)
                        .offset(x: x, y: y)
                        .onTapGesture {
                            inputWord.append(outerLetters[index])
                        }
                }
            }
            .frame(height: 300)
            
            // List of submitted words
            VStack(alignment: .leading) {
                Text("Your words (\(submittedWords.count)):")
                    .font(.headline)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(submittedWords, id: \.self) { word in
                            Text(word)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .alert("Invalid Word", isPresented: $showInvalidWordAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(invalidWordReason)
        }
    }
    
    func submitWord() {
        let word = inputWord.lowercased()
        
        // Check if word is at least 4 letters
        if word.count < 4 {
            showInvalidAlert("Words must be at least 4 letters long")
            return
        }
        
        // Check if word contains the center letter
        if !word.contains(centerLetter.lowercased()) {
            showInvalidAlert("Words must contain the center letter")
            return
        }
        
        // Check if word only contains valid letters
        let validLetters = Set([centerLetter] + outerLetters).map { $0.lowercased() }
        for char in word {
            if !validLetters.contains(String(char)) {
                showInvalidAlert("Words can only contain the given letters")
                return
            }
        }
        
        // Check if word has already been found
        if submittedWords.contains(word) {
            showInvalidAlert("You've already found this word")
            return
        }
        
        // In a real game, you'd validate against a dictionary here
        // For this demo, we'll just accept any valid word
        
        // Add word to list and update score
        submittedWords.append(word)
        updateScore(for: word)
        inputWord = ""
    }
    
    func updateScore(for word: String) {
        // Basic scoring: 1 point per letter, bonus for pangrams
        var points = word.count
        
        // 7-letter words earn extra points
        if word.count >= 7 {
            points += 3
        }
        
        // Pangram bonus (uses all letters)
        let uniqueLetters = Set(word)
        let allLetters = Set([centerLetter] + outerLetters).map { $0.lowercased() }
        if uniqueLetters.count == allLetters.count {
            points += 7
        }
        
        score += points
    }
    
    func deleteLastCharacter() {
        if !inputWord.isEmpty {
            inputWord.removeLast()
        }
    }
    
    func shuffleOuterLetters() {
        outerLetters.shuffle()
    }
    
    func resetGame() {
        // In a real game, you'd generate new letters here
        centerLetter = "T"
        outerLetters = ["A", "C", "I", "P", "R", "S"]
        inputWord = ""
        submittedWords = []
        score = 0
    }
    
    func showInvalidAlert(_ message: String) {
        invalidWordReason = message
        showInvalidWordAlert = true
    }
}

#Preview {
    ContentView()
}
