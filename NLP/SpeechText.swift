import Foundation

class Token {
    var rawText: String
    var parsedText: String

    init(word rawText: String) {
        self.rawText = rawText
        self.parsedText = rawText.lowercased()
        self.parsedText.removeAll(where: { !$0.isLetter })
    }

    var description: String {
        return parsedText
    }
    var filler : Bool {
        return fillers.contains(parsedText)
    }
    
}

class SpeechText {
    var rawText: String
    var rawWords: [String]
    var tokens: [Token]

    init(text rawText: String){
        self.rawText = rawText
        self.rawWords = rawText.components(separatedBy: " ")
        self.tokens = rawWords.map{Token(word: $0)}
    }

    func ngrams(n: Int) -> [String] {
        var grams : [String] = []
        for i in 0..<(tokens.count - n + 1) {
            grams.append(tokens[i...i+n-1].map{$0.parsedText}.joined(separator: " "))
        }
        return grams
    }

    var wordFreq : [String : Int] {
        var freq = [String : Int]()
        for token in tokens {
            if let val = freq[token.rawText] {
                freq[token.rawText] = val + 1
            } else {
                freq[token.rawText] = 1
            }
        }
        return freq
    }

    var numFillers : Int {
        return tokens.map{$0.filler ? 1 : 0}.reduce(0, +)
    }
}

let fillers = [
    "umm", "um", "like",
    "literally", "basically",
    "technically", "ah",
    "totally"
]

let slang = [1 : [
    "con",
    "bazillion",
    "neat",
    "croak",
    "bonkers",
    "cheesy",
    "cushy",
    "airhead",
    "icky",
    "ick",
    "freebie",
    "gig",
    "hustle",
    "glitch",
    "jock",
    "junkie",
    "suck",
    "sucks",
    "oddball",
    "zit",
    "crap",
    "beemer",
    "whiz",
    "vibe",
    "vibes",
    "swag",
    "goof",
    "pissed"
], 2 : [
    "kick back",
    "big guns",
    "deep pockets",
    "fender bender",
    "hang out",
    "go bananas",
    "quick buck",
    "kick back"
]]
