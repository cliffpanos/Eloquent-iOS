import Foundation
import Reductio

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
    var isStop : Bool {
        return stopwords.contains(parsedText)
    }
    
}

class SpeechText {
    var rawText: String
    var rawWords: [String]
    var tokens: [Token]

    let KEYWEIGHT = 5.0

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

    func similarity(to other: SpeechText) -> Double {
        let freqA = self.wordFreq
        let freqB = other.wordFreq
        var totalWeight : Double = 0
        var total : Double = 0
        let keywords = self.keywords + self.keywords
        for k in [String](freqA.keys) + [String](freqB.keys) {
            if stopwords.contains(k) {
                continue
            } else {
                let fa = freqA[k] ?? 0
                let fb = freqB[k] ?? 0
                let sim = 1 - (Double(abs(fa - fb)) / Double(max(fa, fb)))
                let weight = Double(fa + fb) * (keywords.contains(k) ? KEYWEIGHT : 1)
                totalWeight += weight
                total += sim * weight
            }
        }
        return (1.0+ total) / (2.0 + totalWeight)
    }

    // var keywords : [String] {
    //     let KEYS = 5
    //     let keywords = tokens.filter{!$0.isStop}.map{$0.parsedText}.shuffled()
    //     if keywords.count > KEYS {
    //         return [String](keywords[0..<KEYS])
    //     } else {
    //         return keywords
    //     }
    // }

    var keywords : [String] {
        return rawText.keywords
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

    var numSlang : Int {
        var count = 0;
        for n in slang.keys {
            for gram in ngrams(n: n) {
                if slang[n]!.contains(gram) {
                    count += 1
                }
            }
        }
        return count
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

let stopwords = ["", "i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they", "them", "their", "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and", "but", "if", "or",
"because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s", "t", "can", "will", "just", "don", "should", "now"]
