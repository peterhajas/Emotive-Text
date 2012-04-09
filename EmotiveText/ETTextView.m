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

-(void)textChanged
{
    if([currentText length] > 20)
    {
        currentText = @"";
    }
    hasEmotion = [emotionTextAttributer textHasEmotion:currentText];
    [self animate];
}

-(void)animate
{
    attributedText = [[NSMutableAttributedString alloc]
                      initWithAttributedString:[emotionTextAttributer attributedStringForText:currentText
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
    currentText = [currentText stringByAppendingString:aString];
    [self textChanged];
}

-(void)deleteBackward:(id)sender
{
    if([currentText length] > 0)
    {
        currentText = [currentText substringToIndex:[currentText length] - 1];
    }
    else
    {
        currentText = @"";
    }
    [self textChanged];
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
    if([NSStringFromSelector(aSelector) isEqualToString:@"deleteBackward:"])
    {
        [self deleteBackward:nil];
    }
    else
    {
        if([self respondsToSelector:aSelector])
        {
            [self performSelector:aSelector];
        }
    }
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
        animationAssignment = [[ETAnimationAssignment alloc] init];
        [animationAssignment setDelegate:self];
        
        
    }
    
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ETViewResizedNotification"
                                                        object:[NSValue valueWithSize:[self frame].size]];
    
    if([currentText isEqualToString:@""])
    {
        CGPoint center = CGPointMake([self frame].size.width/2,
                                     [self frame].size.height/2 - 10);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ETTextChangedNotification"
                                                            object:[NSValue valueWithPoint:center]];
        
        [self setLayer:[ETLayerChopper setBottomLayerToGradient:[self layer]]];
        
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
        
    CGPoint lineOriginInUs = CGPointMake([self frame].size.width/2 - lineImageFrame.size.width/2 + lineImageFrame.size.width + 10,
                                         [self frame].size.height/2 - lineImageFrame.size.height/2 - 10);
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ETTextChangedNotification"
                                                        object:[NSValue valueWithPoint:lineOriginInUs]];
    
    CGFloat textXPosition = ([self frame].size.width - lineImageFrame.size.width)/2;
    CGFloat textYPosition = ([self frame].size.height - lineImageFrame.size.height)/2;
    
    CGContextSetTextPosition(staleContext, textXPosition, textYPosition);
    
    // Draw the line into the context
    
    CTLineDraw(line, staleContext);
    
    [self setLayer:[ETLayerChopper splitLayer:[self layer] byLine:line inContext:staleContext]];
    
    if(hasEmotion)
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
        [animationAssignment animateLayer:[self layer] forEmotion:firstEmotion];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ETNoEmotionNotification"
                                                                object:nil];
        [animationAssignment animateLayer:[self layer] forEmotion:@"none"];
    }
}

-(NSUInteger)autoresizingMask
{
    return (NSViewWidthSizable | NSViewHeightSizable);
}

-(void)viewDidEndLiveResize
{
    [self setFrame:[self superview].frame];
    [self setNeedsDisplay:YES];
}

-(BOOL)becomeFirstResponder
{
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

-(void)keyDown:(NSEvent *)theEvent
{
    [[NSTextInputContext currentInputContext] handleEvent:theEvent];
}

-(void)lastLayerAnimated
{
    // Set text to nothing, and animate
    currentText = @"";
    [self animate];
}

@end
