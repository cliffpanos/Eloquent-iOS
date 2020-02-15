import Foundation

let qz = Quizlet(url: "https://quizlet.com/190542265/world-war-2-people-flash-cards/")
for card in qz.cards {
    print(card.term, card.definition)
}

print(qz.name)