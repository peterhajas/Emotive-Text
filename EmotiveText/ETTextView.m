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

#import "ETTextView.h"
#import "ETAnimationAssignment.h"
#import "ETLayerChopper.h"

@implementation ETTextView

-(void)animateText:(NSString*)text
{
    currentText = text;
    
    attributedText = [[NSMutableAttributedString alloc]
                      initWithAttributedString:[emotionTextAttributer attributedStringForText:text]];
    
    [self setNeedsDisplay:YES];
}

-(void)funkyAnimationTime
{
    CABasicAnimation* animation;
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animation setFromValue:[NSNumber numberWithFloat:15.0]];
    [animation setToValue:[NSNumber numberWithFloat:0.0]];
    [animation setDuration:0.3];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:CGFLOAT_MAX];
    
    [[self layer] addAnimation:animation forKey:@"blinkAnimation"];
    
    NSLog(@"sublayers: %@", [[self layer] sublayers]);

}

#pragma mark Handling Marked Text
// Marked text is not supported in EmotiveText

-(BOOL)hasMarkedText
{
    return NO;
}

-(NSRange)markedRange
{
    return NSMakeRange(NSNotFound, 0);
}

-(NSRange)selectedRange
{
    return [self markedRange];
}

-(void)setMarkedText:(id)aString selectedRange:(NSRange)selectedRange replacementRange:(NSRange)replacementRange
{
    return;
}

-(void)unmarkText
{
    return;
}

-(NSArray*)validAttributesForMarkedText
{
    return [NSArray arrayWithObject:nil];
}

#pragma mark Storing Text

-(NSAttributedString *)attributedSubstringForProposedRange:(NSRange)aRange actualRange:(NSRangePointer)actualRange
{
    NSString* helloString = @"hello";
    NSAttributedString* attributedHelloString = [[NSAttributedString alloc] initWithString:helloString];
    return attributedHelloString;
}

-(void)insertText:(id)aString replacementRange:(NSRange)replacementRange
{
    NSLog(@"Asked to insert text: %@ at %lu for length %lu", (NSString*)aString, 
                                                             replacementRange.location, 
                                                             replacementRange.length);
}

#pragma mark Getting Character Coordinates

-(NSUInteger)characterIndexForPoint:(NSPoint)aPoint
{
    return 0; // Just 0 for now
}

-(CGRect)firstRectForCharacterRange:(NSRange)aRange actualRange:(NSRangePointer)actualRange
{
    return CGRectMake(0, 0, 0, 0); // 0 for now
}

#pragma mark Binding Keystrokes

-(void)doCommandBySelector:(SEL)aSelector
{
    NSLog(@"Asked to do command by selector %@", NSStringFromSelector(aSelector));
}

#pragma mark View Lifecycle Stuff

-(id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        line = nil;
        currentText = @"";
        
        emotionTextAttributer = [[ETEmotionTextAttributer alloc] init];
    }
    
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{    
    if([currentText isEqualToString:@""])
    {
        return;
    }
    
    staleContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    CFMutableAttributedStringRef attributedString = (__bridge CFMutableAttributedStringRef)attributedText;
    
    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica"), ETTextPointSize, NULL);
    CFAttributedStringSetAttribute(attributedString,
                                   CFRangeMake(0, CFAttributedStringGetLength(attributedString)),
                                   kCTFontAttributeName,
                                   font);
    
    if(line != nil)
    {
        CFRelease(line);
    }
    
    line = CTLineCreateWithAttributedString(attributedString);
    
    CGRect lineImageFrame = CTLineGetImageBounds(line, staleContext);
    
    CGFloat textXPosition = ([self frame].size.width - lineImageFrame.size.width)/2;
    CGFloat textYPosition = ([self frame].size.height - lineImageFrame.size.height)/2;
    
    CGContextSetTextPosition(staleContext, textXPosition, textYPosition);
    
    CTLineDraw(line, staleContext);
    
    // Find the first emotion mentioned in the attributed string
    NSString* firstEmotion = @"";
    for(NSUInteger i = 0; i < [currentText length]; i++)
    {
        NSDictionary* attributesAtIndex = [attributedText attributesAtIndex:i effectiveRange:NULL];
        if([[attributesAtIndex allKeys] containsObject:ETEmotionAttributeKey])
        {
            firstEmotion = [attributesAtIndex valueForKey:ETEmotionAttributeKey];
            break;
        }
    }
    
    [ETLayerChopper splitLayer:[self layer] byLine:line];
    
    // Animate according to the first emotion
    [ETAnimationAssignment animateLayer:[self layer] forEmotion:firstEmotion];
}

-(NSUInteger)autoresizingMask
{
    return (NSViewWidthSizable | NSViewHeightSizable);
}

-(void)viewDidEndLiveResize
{
    [self setNeedsDisplay:YES];
}

@end
