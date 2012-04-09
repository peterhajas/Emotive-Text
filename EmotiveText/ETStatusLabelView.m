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

#import "ETStatusLabelView.h"

@implementation ETStatusLabelView

-(id)init
{
    self = [super initWithFrame:NSMakeRect(0,
                                           0,
                                           400,
                                           200)];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewResized:)
                                                     name:@"ETViewResizedNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(noEmotion)
                                                     name:@"ETNoEmotionNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChanged)
                                                     name:@"ETTextChangedNotification"
                                                   object:nil];
    }
    
    [self setBackgroundColor:[NSColor clearColor]];
    [self alignCenter:nil];
    [self setWantsLayer:YES];
    
    return self;
}

-(void)viewResized:(NSNotification*)notification;
{
    CGSize newViewSize = [[notification object] sizeValue];
    [self setFrame:NSMakeRect((newViewSize.width - ETStatusLabelViewWidth) / 2,
                              200,
                              ETStatusLabelViewWidth,
                              ETStatusLabelViewHeight)];
}

-(void)noEmotion
{
    [self performSelector:@selector(provideHint)
               withObject:nil
               afterDelay:3];
}

-(void)textChanged
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(provideHint)
                                               object:nil];
    [self setString:@""];
}

-(void)provideHint
{
    [self setString:@"try a phrase with feeling"];
    CABasicAnimation* fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeAnimation setFromValue:[NSNumber numberWithInt:0]];
    [fadeAnimation setToValue:[NSNumber numberWithInt:1]];
    [fadeAnimation setDuration:1.0];
    
    [[self layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

-(BOOL)acceptsFirstResponder
{
    return NO;
}

-(BOOL)becomeFirstResponder
{
    return NO;
}

@end
