import Foundation
import Kanna

class Quizlet {
    var url: URL
    init(url: String) {
        self.url = URL(string: url)!
        if let doc = HTML(url: url, encoding: .utf8) {

        }
    }
}