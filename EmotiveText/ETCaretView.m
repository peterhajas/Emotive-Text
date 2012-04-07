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

#import "ETCaretView.h"
#import "ETTextView.h"
#define ETTextCaretViewWidth 5

@implementation ETCaretView

-(id)init
{
    self = [super initWithFrame:CGRectMake(0,
                                           0,
                                           ETTextCaretViewWidth,
                                           ETTextPointSize)];
    [self setWantsLayer:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChangedWithNotification:)
                                                 name:@"ETTextChangedNotification"
                                               object:nil];
    
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation setToValue:[NSNumber numberWithFloat:0.0]];
    [animation setDuration:0.3];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:CGFLOAT_MAX];
    
    [[self layer] addAnimation:animation forKey:@"blinkAnimation"];

    
    return self;
}

-(void)textChangedWithNotification:(NSNotification*)notification
{
    CGPoint ourOrigin = [[notification object] pointValue];
    [self setFrame:NSMakeRect(ourOrigin.x,
                              ourOrigin.y,
                              ETTextCaretViewWidth,
                              ETTextPointSize)];
}

-(void)drawRect:(NSRect)dirtyRect
{
    [[NSColor redColor] setFill];
    NSRectFill(dirtyRect);
}

@end
