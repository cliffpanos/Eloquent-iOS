import Foundation

enum StudentStatus {
    case unsatisfied(String)
    case satisfied(LearnData)
}

struct LearnData {
    var coverage: Double
}

class VirtualStudent {
    var topic : LearnItem
    var status: StudentStatus
    var tries : Int = 0

    let MAX_TRIES = 2

    var keywords : [String]
    var numKeywords : Int

    init(topic : LearnItem) {
        self.topic = topic
        self.status = .unsatisfied("Explain \"\(topic.term)\" to me.")
        let st = SpeechText(text: topic.definition)
        self.keywords = st.keywords
        self.numKeywords = keywords.count
    }

    func listenTo(text: String) -> StudentStatus {
        let st = SpeechText(text: text)
        for token in st.tokens {
            if let index = keywords.firstIndex(of: token.parsedText) {
                keywords.remove(at: index)
            }
        }
        if tries < MAX_TRIES && !keywords.isEmpty {
            let prompt = keywords.randomElement()
            status = .unsatisfied("How is that related to \"\(prompt!)\"?")
            tries += 1
            return status
        }
        let coverage = Double(numKeywords - (keywords.count)) / Double(numKeywords)
        let ld = LearnData(coverage: coverage)
        status = .satisfied(ld)
        return status
    }
}