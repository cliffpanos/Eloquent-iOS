import Foundation

enum StudentStatus {
    case unsatisfied(String)
    case satisfied(LearnData)
}

struct LearnData {
    var coverage: Double
}

fileprivate let tagger = NSLinguisticTagger(tagSchemes:[.lemma], options: 0)
fileprivate let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]

class VirtualStudent {
    var topic : LearnItem
    var status: StudentStatus
    var tries : Int = 0

    let MAX_TRIES = 2
    let RATIO_LEFT = 0.4

    var st : SpeechText
    var keywords : [String]
    var numKeywords : Int

    init(topic : LearnItem) {
        self.topic = topic
        self.status = .unsatisfied("Explain \"\(topic.term)\" to me.")
        self.st = SpeechText(text: topic.definition)
        self.keywords = VirtualStudent.lemmatize(text: st.keywords.joined(separator: " "))
        self.numKeywords = keywords.count
    }

    func listenTo(text: String) -> StudentStatus {
        for lemma in VirtualStudent.lemmatize(text: text) {
            if let index = keywords.firstIndex(of: lemma) {
                keywords.remove(at: index)
            }
        }
        if tries < MAX_TRIES && (Double(keywords.count) > RATIO_LEFT * Double(numKeywords))  {
            let prompt = keywords.randomElement()
            status = .unsatisfied("How is \(topic.term) related to \"\(prompt!)\"?")
            tries += 1
            return status
        }
        let coverage = Double(numKeywords - (keywords.count)) / Double(numKeywords)
        let ld = LearnData(coverage: coverage)
        status = .satisfied(ld)
        return status
    }

    private static func lemmatize(text: String) -> [String] {
        var lemmas = [String]()
        tagger.string = text
        let range = NSRange(location:0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, tokenRange, stop in
            if let lemma = tag?.rawValue {
                lemmas.append(lemma)
            }
        }
        return lemmas
    }
}
