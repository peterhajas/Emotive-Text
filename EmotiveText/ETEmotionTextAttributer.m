/* Copyright (c) 2012, individual contributors
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#import "ETEmotionTextAttributer.h"
#import "ETFontAssignment.h"
#import <Python/Python.h>

@implementation ETEmotionTextAttributer

-(id)init
{
    self = [super init];
    if(self)
    {
        // Grab the emotion dictionary from file
        emotionMapping = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emotion" 
                                                                                                      ofType:@"plist"]];
    }
    return self;
}

-(BOOL)textHasEmotion:(NSString*)text
{
    NSDictionary* mapping = [self emotionMappingForText:text];
    return [[mapping allKeys] count] > 0;
}

-(NSAttributedString*)attributedStringForText:(NSString*)text withEmotion:(BOOL)emotion
{
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedString setAttributes:[NSDictionary dictionaryWithObject:[ETFontAssignment fontForEmotion:@"None"]
                                                              forKey:NSFontAttributeName]
                              range:[text rangeOfString:text]];
    
    if(emotion)
    {
        NSDictionary* mapping = [self emotionMappingForText:text];

        // For each emotion, set the text for that emotion to an appropriate typeface
        
        for(NSString* key in [mapping allKeys])
        {
            // For each word with this emotion, set the typeface
            
            NSFont* emotionFont = [ETFontAssignment fontForEmotion:key];
            
            for(NSString* word in (NSArray*)[mapping valueForKey:key])
            {
                NSRange rangeForWord = [text rangeOfString:word];
                [attributedString setAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                                                     emotionFont,
                                                                                     key,
                                                                                     nil]
                                                                            forKeys:[NSArray arrayWithObjects:
                                                                                     NSFontAttributeName,
                                                                                     ETEmotionAttributeKey,
                                                                                     nil]]
                                          range:[text rangeOfString:text]];
            }
        }
    }
        
    return attributedString;
}

-(NSDictionary*)emotionMappingForText:(NSString*)text
{
    NSMutableDictionary* mapping = [[NSMutableDictionary alloc] init];
    
    // Split text into composite words.
    NSArray* words = [text componentsSeparatedByString:@" "];
    for(NSString* word in words)
    {
        // Split these components by punctuation
        NSArray* components = [word componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
        for(NSString* component in components)
        {
            NSString* lowercaseWord = [component lowercaseString];
            for(NSString* key in [emotionMapping allKeys])
            {
                if([[emotionMapping valueForKey:key] containsObject:lowercaseWord])
                {
                    // This word has that emotion! Populate mapping with it
                    if(![[mapping allKeys] containsObject:key])
                    {
                        // If mapping doesn't have this key, create it
                        [mapping setValue:[[NSMutableArray alloc] init] forKey:key];
                    }
                    NSMutableArray* wordsWithEmotion = [mapping valueForKey:key];
                    [wordsWithEmotion addObject:lowercaseWord];
                }
            }
        }
    }

    return mapping;
}

@end
