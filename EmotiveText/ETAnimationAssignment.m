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

#import "ETAnimationAssignment.h"
#include <stdlib.h>

@implementation ETAnimationAssignment

@synthesize delegate;

-(void)animateLayer:(CALayer*)layer forEmotion:(NSString*)emotion
{    
    for(int i = 0; i < 2; i++)
    {
        float delayAmount = 0;
        for(CALayer* sublayer in [layer sublayers])
        {
            if([[layer sublayers] indexOfObject:sublayer] == 0)
            {
                continue;
            }
            
            BOOL isLastLayer = NO;
            
            if([sublayer isEqualTo:[[layer sublayers] lastObject]])
            {
                isLastLayer = YES;
            }
            
            NSArray* argumentsArray = [NSArray arrayWithObjects:sublayer,
                                                                emotion,
                                                                [NSNumber numberWithBool:isLastLayer],
                                                                nil];
            
            [self performSelector:@selector(animateSublayerForEmotion:)
                       withObject:argumentsArray
                       afterDelay:delayAmount];
            
            delayAmount += 0.08;
        }
    }
}

-(void)animateSublayerForEmotion:(NSArray*)arguments
{
    CALayer* sublayer = [arguments objectAtIndex:0];
    NSString* emotion = [arguments objectAtIndex:1];
    BOOL isLastLayer = [[arguments objectAtIndex:2] boolValue];
    BOOL shouldTellDelegate = YES;
    
    CGRect oldFrame = [sublayer frame];
    [sublayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [sublayer setFrame:oldFrame];
    
    [sublayer removeAllAnimations];
    
    CAAnimation* emotionAnimation = nil;
    
    if([emotion isEqualToString:@"anger"])
    {
        emotionAnimation = [self animationAnger];
    }
    else if([emotion isEqualToString:@"disgust"])
    {
        emotionAnimation = [self animationDisgust];
    }
    else if([emotion isEqualToString:@"fear"])
    {
        emotionAnimation = [self animationFear];
    }
    else if([emotion isEqualToString:@"joy"])
    {
        emotionAnimation = [self animationJoy];
    }
    else if([emotion isEqualToString:@"sadness"])
    {
        emotionAnimation = [self animationSadness];
    }
    else if([emotion isEqualToString:@"surprise"])
    {
        emotionAnimation = [self animationSurprise];
    }
    else if([emotion isEqualToString:@"none"])
    {
        emotionAnimation = [self animationNone];
        shouldTellDelegate = NO;
    }
    else
    {
        NSLog(@"Unknown animation for emotion %@", emotion);
    }
    
    if(emotionAnimation != nil)
    {
        if(isLastLayer && shouldTellDelegate)
        {
            [emotionAnimation setDelegate:self];
        }
        [sublayer addAnimation:emotionAnimation forKey:@"EmotionAnimation"];
    }
}

-(CAAnimation*)animationAnger
{
    CABasicAnimation* popOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    [popOutAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [popOutAnimation setToValue:[NSNumber numberWithFloat:1.8]];
    [popOutAnimation setDuration:0.1];
    [popOutAnimation setAutoreverses:YES];
    [popOutAnimation setRepeatCount:2];
    [popOutAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    return popOutAnimation;
}

-(CAAnimation*)animationDisgust
{    
    float duration = (float)rand()/(float)RAND_MAX + 8;
    
    CABasicAnimation* runAwayAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [runAwayAnimation setFromValue:[NSNumber numberWithInt:1.0]];
    [runAwayAnimation setToValue:[NSNumber numberWithInt:0.1]];
    [runAwayAnimation setDuration:duration];
    
    CABasicAnimation* jumpAnimation = [CABasicAnimation animationWithKeyPath:
                                       @"transform.translation.y"];
    [jumpAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
    [jumpAnimation setToValue:[NSNumber numberWithFloat:10.0]];
    [jumpAnimation setDuration:0.1];
    [jumpAnimation setAutoreverses:YES];
    [jumpAnimation setRepeatCount:30];
    
    CAAnimationGroup* animationGroup = [[CAAnimationGroup alloc] init];
    [animationGroup setAnimations:[NSArray arrayWithObjects:runAwayAnimation,
                                                            jumpAnimation,
                                                            nil]];
    
    return animationGroup;
}

-(CAAnimation*)animationFear
{
    CABasicAnimation* shiverAnimation = [CABasicAnimation animationWithKeyPath:
                                         @"transform.translation.x"];
    [shiverAnimation setFromValue:[NSNumber numberWithFloat:-5.0]];
    [shiverAnimation setToValue:[NSNumber numberWithFloat:5.0]];
    [shiverAnimation setDuration:0.05];
    [shiverAnimation setAutoreverses:YES];
    [shiverAnimation setRepeatCount:20.0];
            
    return shiverAnimation;
}

-(CAAnimation*)animationJoy
{
    int toValue = rand() % 55;
    
    CABasicAnimation* jumpAnimation = [CABasicAnimation animationWithKeyPath:
                                       @"transform.translation.y"];
    [jumpAnimation setFromValue:[NSNumber numberWithFloat:0]];
    [jumpAnimation setToValue:[NSNumber numberWithFloat:toValue]];
    [jumpAnimation setDuration:0.1];
    [jumpAnimation setAutoreverses:YES];
    [jumpAnimation setRepeatCount:1];
    
    return jumpAnimation;
}

-(CAAnimation*)animationSadness
{
    float duration = (float)rand()/(float)RAND_MAX + 8;
    
    CABasicAnimation* rainAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [rainAnimation setFromValue:[NSNumber numberWithInt:0.0]];
    [rainAnimation setToValue:[NSNumber numberWithInt:-1000]];
    [rainAnimation setDuration:duration];
    
    return rainAnimation;
}

-(CAAnimation*)animationSurprise;
{
    float toValue = 1 + (float)rand()/(float)RAND_MAX;

    CABasicAnimation* shockAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [shockAnimation setFromValue:[NSNumber numberWithInt:1.0]];
    [shockAnimation setToValue:[NSNumber numberWithFloat:toValue]];
    [shockAnimation setDuration:0.1];
    
    return shockAnimation;
}

-(CAAnimation*)animationNone;
{
    CABasicAnimation* fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [fadeAnimation setToValue:[NSNumber numberWithFloat:0.3]];
    [fadeAnimation setDuration:3.5];
    [fadeAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    return fadeAnimation;
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if(flag)
    {
        [delegate lastLayerAnimated];
    }
}

@end
