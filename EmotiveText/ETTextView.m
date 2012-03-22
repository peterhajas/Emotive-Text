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

@implementation ETTextView

-(void)animateText:(NSString*)text
{
    currentText = text;
    attributedText = [[NSMutableAttributedString alloc] initWithString:currentText];
    [self setNeedsDisplay:YES];
    [self funkyAnimationTime];
}

-(void)funkyAnimationTime
{
    NSLog(@"layer: %@", [self layer]);
    
    CABasicAnimation* animation;
    
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation setToValue:[NSNumber numberWithFloat:0.0]];
    [animation setDuration:0.3];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:CGFLOAT_MAX];
    
    [[self layer] addAnimation:animation forKey:@"blinkAnimation"];

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
        [self setWantsLayer:YES];
    }
    
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if([currentText isEqualToString:@""])
    {
        return;
    }
    
    staleContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    CFMutableAttributedStringRef attributedString = (__bridge CFMutableAttributedStringRef)attributedText;
    
    if(line != nil)
    {
        CFRelease(line);
    }
    
    line = CTLineCreateWithAttributedString(attributedString);
    
    CGContextSetTextPosition(staleContext, 0.0, 0.0);
    
    CTLineDraw(line, staleContext);
}

@end
