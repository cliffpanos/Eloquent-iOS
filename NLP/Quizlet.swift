import Foundation
import FoundationNetworking
import Kanna

class Quizlet {
    var url: URL
    var name: String
    var cards: [LearnItem]
    var title: String
    init(url urlString: String) {
        self.url = URL(string: urlString)!
        self.cards = []
        let html = try? String(contentsOf: url)
        let doc = (try? HTML(html: html!, encoding: .utf8))!

        for node in doc.css(".SetPageTerm-content") {
            let termDef = node.css(".TermText")
            if let term = termDef[0].text {
                if let def = termDef[1].text {
                    cards.append(LearnItem(term: term, definition: def))
                }
            }
        }
        name = doc.at_css(".UIHeading--one")!.text!
    }
}