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
#import "ETFontAssignment.h"

@implementation ETTextView

-(void)animateText:(NSString*)text
{
    currentText = text;
    
    attributedText = [[NSMutableAttributedString alloc]
                      initWithAttributedString:[emotionTextAttributer attributedStringForText:text
                                                                                  withEmotion:YES]];
        
    [self setNeedsDisplay:YES];
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
    return [NSArray arrayWithObject:NSFontAttributeName];
}

#pragma mark Storing Text

-(NSAttributedString *)attributedSubstringForProposedRange:(NSRange)aRange actualRange:(NSRangePointer)actualRange
{
    return attributedText;
}

-(void)insertText:(id)aString replacementRange:(NSRange)replacementRange
{
    pendingText = [pendingText stringByAppendingString:aString];
    currentText = pendingText;
    attributedText = [[NSMutableAttributedString alloc]
                      initWithAttributedString:[emotionTextAttributer attributedStringForText:pendingText
                                                                                  withEmotion:NO]];
    [self setNeedsDisplay:YES];
}

-(void)deleteBackward:(id)sender
{
    if([pendingText length] > 0)
    {
        pendingText = [pendingText substringToIndex:[pendingText length]-1];
        currentText = pendingText;
        attributedText = [[NSMutableAttributedString alloc]
                          initWithAttributedString:[emotionTextAttributer attributedStringForText:pendingText
                                                                                      withEmotion:NO]];
    }
    else
    {
        [self setLayer:[ETLayerChopper setBottomLayerToGradient:[self layer]]];
    }
         
    [self setNeedsDisplay:YES];
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
    [self performSelector:aSelector];
}

#pragma mark View Lifecycle Stuff

-(id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        line = nil;
        currentText = @"";
        pendingText = @"";
        
        emotionTextAttributer = [[ETEmotionTextAttributer alloc] init];
        
        shouldAnimate = NO;
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
        
    if(line != nil)
    {
        CFRelease(line);
    }
    
    line = CTLineCreateWithAttributedString(attributedString);
    
    CGRect lineImageFrame = CTLineGetImageBounds(line, staleContext);
    
    CGFloat textXPosition = ([self frame].size.width - lineImageFrame.size.width)/2;
    CGFloat textYPosition = ([self frame].size.height - lineImageFrame.size.height)/2;
    
    CGContextSetTextPosition(staleContext, textXPosition, textYPosition);
    
    // Draw the line into the context
    
    CTLineDraw(line, staleContext);
    
    [self setLayer:[ETLayerChopper splitLayer:[self layer] byLine:line inContext:staleContext]];
    
    if(shouldAnimate)
    {
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
        
        // Animate according to the first emotion
        [ETAnimationAssignment animateLayer:[self layer] forEmotion:firstEmotion];

        shouldAnimate = NO;
    }
}

-(NSUInteger)autoresizingMask
{
    return (NSViewWidthSizable | NSViewHeightSizable);
}

-(void)viewDidEndLiveResize
{
    [self setNeedsDisplay:YES];
}

-(BOOL)becomeFirstResponder
{
    NSLog(@"become first responder");
    return YES;
}

-(BOOL)resignFirstResponder
{
    return NO;
}

-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(void)insertNewline:(id)sender
{
    shouldAnimate = YES;
    [self animateText:pendingText];
    pendingText = @"";
}

-(void)keyDown:(NSEvent *)theEvent
{
    [[NSTextInputContext currentInputContext] handleEvent:theEvent];
}

@end
