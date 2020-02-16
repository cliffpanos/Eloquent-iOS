import Foundation

// let qz = Quizlet(url: "https://quizlet.com/190542265/world-war-2-people-flash-cards/")
// for card in qz.cards {
//     print(card.term, card.definition)
// }

// print(qz.name)

let ww2Text = "World War II, also known as the Second World War, was a global war that lasted from 1939 to 1945. The vast majority of the world's countries — including all the great powers — eventually formed two opposing military alliances: the Allies and the Axis. A state of total war emerged, directly involving more than 100 million people from more than 30 countries."
let ww2Text2 = "World War II, aka the Second World War, lasted from 1939 to 1945. The Allies and the Axis, two opposing alliances, were formed. The vast majority of the world's countries fought. Total war ensued"

let ww2 = LearnItem(term: "World War II", definition: ww2Text)
   
let vs = VirtualStudent(topic: ww2)
print(vs.status)
vs.listenTo(text: "World War II was a global war, composed of two military alliances: The axis and the allies")
print(vs.status)
vs.listenTo(text: "Eventually, the war ended in defeat for the axis")
print(vs.status)
vs.listenTo(text: "Countries involved included the US and Germany")
print(vs.status)

let st = SpeechText(text: ww2Text)
let st2 = SpeechText(text: ww2Text2)
let st3 = SpeechText(text: "")
print(st3.tokens.count)
print(st.similarity(to: st2))