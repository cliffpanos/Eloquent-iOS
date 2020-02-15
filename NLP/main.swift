let st = SpeechText(text: "Some, words, are, like, totally here. Wow")
for token in st.tokens {
    print("\(token.parsedText) \(token.rawText)")
}
print("\(st.numFillers)")
print("\(st.ngrams(n: 2))")