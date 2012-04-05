import sys,os
import en
import pickle

def emotion_for_word(word):
    
    emotion = None
    
    emotion = en.adjective.is_emotion(word, boolean=False)
    if emotion is None:
        emotion = en.adverb.is_emotion(word, boolean=False)
    if emotion is None:
        emotion = en.noun.is_emotion(word, boolean=False)
    if emotion is None:
        emotion = en.verb.is_emotion(word, boolean=False)
    
    return emotion


dict = open("/usr/share/dict/words")

dict_emotion_mapping = { }

first_letter = 'z'

for word in dict:
    if word[:1].lower() != first_letter:
        first_letter = word[:1].lower()
        print "Processing {}".format(first_letter)
    word = word[:-1]
    emotion = emotion_for_word(word)
    if emotion is not None:
        if emotion not in dict_emotion_mapping.keys():
            dict_emotion_mapping[emotion] = [ ]
        dict_emotion_mapping[emotion].append(word)

outfile = open("emotion_dict", 'w')

pickle.dump(dict_emotion_mapping, outfile)