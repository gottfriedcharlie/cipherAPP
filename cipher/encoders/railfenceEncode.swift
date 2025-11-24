//
//  ralifenceEncode.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/24/25.
//

struct railfenceEncode{
    
    static func encrypt(plainText: String, rails: Int) -> String{
        
        //clean the input - remove spaces and special characters, keep only letters
        //was running it whitespace issue when encryting and decryptin so no more whitespace
        let cleanText = plainText.filter { $0.isLetter }
        
        guard rails > 1 else { return cleanText }
        guard !cleanText.isEmpty else { return "" }
        
        //creates array of empty strings
        var railStrings = Array(repeating: "", count: rails)
        
        var currentRail = 0
        var goingDown = false
        
        for char in cleanText{
            //taking the current char and putting it in its correct string
            //if at top puts it in first string, bottom last string
            railStrings[currentRail].append(char)
            
            //if at top or bottom 0 for top of the rails
            //-1 for bottom we switch the direction of the text read
            if currentRail == 0 || currentRail == rails - 1{
                goingDown.toggle()
            }
            
            //if we are going down we add one to the currentRail advacning it down one more
            //if we are going up we subtract so it goes up
            currentRail += goingDown ? 1 : -1
        }
        
        //joining the array to one single element and making it a string
        return String(railStrings.joined())
    }
}
