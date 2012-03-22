import en

def emotions_for_sentence(sentence):
    
    adjectives = [ ]
    adverbs = [ ]
    nouns = [ ]
    verbs = [ ]
    
    emotion_word_matches = { }
    
    def add_word_and_emotion(word,emotion):
        if emotion not in emotion_word_matches.keys():
            emotion_word_matches[emotion] = [ ]
        
        emotion_word_matches[emotion].append(word)
    
    # Remove all punctuation from the sentence
    punctuation = ["\'","\"",",",".","!","?",";",":","-"]
    
    words = sentence.split()
    
    # Group words by type
    for word in words:
        if en.is_adjective(word):
            adjectives.append(word)
        elif en.is_adverb(word):
            adverbs.append(word)
        elif en.is_noun(word):
            nouns.append(word)
        elif en.is_verb(word):
            verbs.append(word)
    
    for adjective in adjectives:
        emotion = en.adjective.is_emotion(adjective, boolean=False)
        add_word_and_emotion(adjective, emotion)
        
    for adverb in adverbs:
        emotion = en.adverb.is_emotion(adverb, boolean=False)
        add_word_and_emotion(adverb, emotion)
        
    for noun in nouns:
        emotion = en.noun.is_emotion(noun, boolean=False)
        add_word_and_emotion(noun, emotion)
        
    for verb in verbs:
        emotion = en.verb.is_emotion(verb, boolean=False)
        add_word_and_emotion(verb, emotion)
        
    return emotion_word_matches
    

print "emotion loaded"
    
    