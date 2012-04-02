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
        // Initialize Python
        
        Py_Initialize();
        
        // Append the resource path to sys.path
        
        NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
                
        NSString* appendToSysPathCommand = [NSString stringWithFormat:@"import sys; sys.path.append(\"%@\")", resourcePath];
        
        PyRun_SimpleString([appendToSysPathCommand cStringUsingEncoding:NSUTF8StringEncoding]);
        
        // Import the emotion code
        
        emotion = PyImport_ImportModule("emotion");
        
        
    }
    return self;
}

-(NSAttributedString*)attributedStringForText:(NSString*)text
{
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedString setAttributes:[NSDictionary dictionaryWithObject:[ETFontAssignment fontForEmotion:@"None"]
                                                              forKey:NSFontAttributeName]
                              range:[text rangeOfString:text]];
    
    NSDictionary* emotionMapping = [self emotionMappingForText:text];

    // For each emotion, set the text for that emotion to an appropriate typeface
    
    for(NSString* key in [emotionMapping allKeys])
    {
        // For each word with this emotion, set the typeface
        
        NSFont* emotionFont = [ETFontAssignment fontForEmotion:key];
        
        for(NSString* word in (NSArray*)[emotionMapping valueForKey:key])
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
        
    return attributedString;
}

-(NSDictionary*)emotionMappingForText:(NSString*)text
{
    PyObject* emotionDict = PyObject_CallMethod(emotion, "emotions_for_sentence", "s", [text cStringUsingEncoding:NSUTF8StringEncoding]);
    
    if(emotionDict == NULL)
    {
        NSLog(@"Problem grabbing emotions!");
        PyErr_PrintEx(0);
        return nil;
    }
    
    // Grab all the keys for the emotionDict
    
    PyObject* keys = PyDict_Keys(emotionDict);
        
    // Loop through all the keys, and build our dictionary
    
    NSMutableDictionary* emotionMapping = [[NSMutableDictionary alloc] init];
    
    Py_ssize_t keysLength = PyList_Size(keys);
    
    for(NSUInteger i = 0; i < keysLength; i++)
    {
        PyObject* key = PyList_GetItem(keys, i);        
        if(PyString_Check(key))
        {
            // Grab the key
            char* keyCString = PyString_AsString(key);
            NSString* keyFoundationString = [NSString stringWithCString:keyCString 
                                                               encoding:NSUTF8StringEncoding];
            
            // Loop through all the values for this key, and add them to a mutable array
            
            PyObject* values = PyDict_GetItem(emotionDict, key);
            
            NSMutableArray* valuesFoundationArray =  [[NSMutableArray alloc] init];
            
            Py_ssize_t valuesLength = PyList_Size(values);
            
            for(NSUInteger j = 0; j < valuesLength; j++)
            {
                PyObject* value = PyList_GetItem(values, j);
                
                char* valueCString = PyString_AsString(value);
                
                NSString* valueFoundationString = [NSString stringWithCString:valueCString 
                                                                     encoding:NSUTF8StringEncoding];
                
                [valuesFoundationArray addObject:valueFoundationString];
            }
            
            // Populate our dictionary with this key and its value array
            
            [emotionMapping setValue:valuesFoundationArray
                              forKey:keyFoundationString];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:emotionMapping];
}

@end
