import Foundation
import Kanna

class Quizlet {
    var cards: [LearnItem]
    var title: String
    init(htmlData: String) {
        let doc = (try? HTML(html: htmlData, encoding: .utf8))!
        self.title = doc.at_css(".UIHeading--one")?.text ?? "Practice Set"
        self.cards = []
        for node in doc.css(".SetPageTerm-content") {
            let termDef = node.css(".TermText")
            if let term = termDef[0].text {
                if let def = termDef[1].text {
                    cards.append(LearnItem(term: term, definition: def))
                }
            }
        }
    }
    convenience init(urlString: String) {
        let url = URL(string: urlString)!
        let html = try? String(contentsOf: url)
        self.init(htmlData: html!)
    }
}
