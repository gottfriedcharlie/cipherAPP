//
//  englishLike.swift
//  cipher
//
//  Created by Charlie Gottfried on 11/23/25.
//

struct englishLike {
    
    //this trys to guess if text looks like english by looking for common words and vowel stuff
    static func scoreEnglishLikelihood(text: String) -> Double {
        let lower = text.lowercased()
        var score = 0.0
        
        //list of super common english words, if these appear then probably real english
        let commonWords = ["the", "be", "to", "of", "and", "a", "in", "that", "have", "I", "it", "for", "not", "on", "with", "he", "as", "you", "do", "at", "this", "but", "his", "by", "from", "they", "we", "say", "her", "she", "or", "an", "will", "my", "one", "all", "would", "there", "their", "what", "so", "up", "out", "if", "about", "who", "get", "which", "go", "me", "when", "make", "can", "like", "time", "no", "just", "him", "know", "take", "people", "into", "year", "your", "good", "some", "could", "them", "see", "other", "than", "then", "now", "look", "only", "come", "its", "over", "think", "also", "back", "after", "use", "two", "how", "our", "work", "first", "well", "way", "even", "new", "want", "because", "any", "these", "give", "day", "most", "us", "is", "are", "was", "were", "had", "been", "did", "has", "more", "very", "down", "really", "many", "those", "may", "might", "long", "still", "here", "where", "why", "before", "through", "shall", "must", "never", "ever", "again", "tell", "try", "much", "went", "does", "off", "hand", "head", "eye", "life", "man", "woman", "child", "world", "house", "place", "small", "big", "great", "same", "few", "another", "each", "every", "next", "last", "right", "left", "high", "low", "old", "young", "home", "school", "state", "country", "part", "case", "group", "number", "point", "fact", "story", "family", "student", "week", "company", "system", "program", "question", "government", "problem", "night", "mr", "mrs", "area", "money", "history", "month", "lot", "power", "study", "game", "job", "business", "issue", "side", "kind", "sort", "face", "room", "door", "water", "food", "air", "car", "street", "city", "body", "mind", "name", "hour", "friend", "teacher", "parent", "office", "moment", "morning", "evening", "change", "interest", "reason", "level", "process", "result", "idea", "truth", "sense", "news", "line", "figure", "order", "form", "matter", "community", "service", "research", "action", "force", "police", "policy", "decision", "effect", "public", "society", "center", "attention", "position", "value", "practice", "technology", "industry", "nature", "field", "role", "relationship", "language", "purpose", "respect", "support", "care", "love", "thank", "hope", "dream", "fear", "chance", "plan", "future", "past", "goal", "memory", "list", "search", "start", "stop", "run", "walk", "talk", "hear", "listen", "speak", "call", "move", "play", "share", "show", "build", "write", "read", "open", "close", "watch", "sit", "stand", "wait", "use", "help", "hold", "lead", "follow", "live", "die", "believe", "feel", "seem", "learn", "understand", "remember", "forget", "remain", "stay", "continue", "begin", "end", "create", "spend", "win", "lose", "pay", "buy", "sell", "send", "receive", "meet", "reach", "allow", "appear", "serve", "support", "develop", "happen", "include", "require", "suggest", "expect", "consider", "increase", "reduce", "produce", "provide", "agree", "offer", "decide", "explain", "teach", "change", "improve", "choose", "cause", "accept", "avoid", "compare", "control", "determine", "answer", "apply", "judge", "wish", "prefer", "act"]
        
        // boost score whenever we find one of those words inside
        for word in commonWords {
            if lower.contains(word) {
                score += 10.0
            }
        }
        
        //vowels check, english has a decent amount of vowels, if too few, probably not english
        let vowels = "aeiou"
        let vowelCount = lower.filter { vowels.contains($0) }.count
        let vowelRatio = Double(vowelCount) / Double(text.count)
        
        //if vowel ratio is tiny, its prob garbage decrypt so punish score
        if vowelRatio < 0.2 {
            score -= 20.0
        }
        
        return score
    }
}
