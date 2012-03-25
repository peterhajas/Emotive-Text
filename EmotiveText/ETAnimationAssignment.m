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

+(void)animateLayer:(CALayer*)layer forEmotion:(NSString*)emotion
{    
    for(int i = 0; i < 2; i++)
    {
        float delayAmount = 0;
        for(CALayer* sublayer in [layer sublayers])
        {
            NSArray* argumentsArray = [NSArray arrayWithObjects:sublayer, emotion, nil];
            
            [ETAnimationAssignment performSelector:@selector(animateSublayerForEmotion:)
                                        withObject:argumentsArray
                                        afterDelay:delayAmount];
            
            delayAmount += 0.08;
        }
    }
}

+(void)animateSublayerForEmotion:(NSArray*)arguments
{
    CALayer* sublayer = [arguments objectAtIndex:0];
    NSString* emotion = [arguments objectAtIndex:1];
    
    CGRect oldFrame = [sublayer frame];
    [sublayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [sublayer setFrame:oldFrame];
    
    [sublayer removeAllAnimations];
    
    if([emotion isEqualToString:@"anger"])
    {
        [ETAnimationAssignment animateLayerAnger:sublayer];
    }
    else if([emotion isEqualToString:@"disgust"])
    {
        [ETAnimationAssignment animateLayerDisgust:sublayer];
    }
    else if([emotion isEqualToString:@"fear"])
    {
        [ETAnimationAssignment animateLayerFear:sublayer];
    }
    else if([emotion isEqualToString:@"joy"])
    {
        [ETAnimationAssignment animateLayerJoy:sublayer];
    }
    else if([emotion isEqualToString:@"sadness"])
    {
        [ETAnimationAssignment animateLayerSadness:sublayer];
    }
    else if([emotion isEqualToString:@"surprise"])
    {
        [ETAnimationAssignment animateLayerSurprise:sublayer];
    }
}

+(void)animateLayerAnger:(CALayer*)layer
{
    CABasicAnimation* popOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    [popOutAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [popOutAnimation setToValue:[NSNumber numberWithFloat:1.2]];
    [popOutAnimation setDuration:0.1];
    [popOutAnimation setAutoreverses:YES];
    [popOutAnimation setRepeatCount:CGFLOAT_MAX];
    
    CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    [rotateAnimation setFromValue:[NSNumber numberWithFloat:-0.1]];
    [rotateAnimation setToValue:[NSNumber numberWithFloat:0.1]];
    [rotateAnimation setDuration:0.3];
    [rotateAnimation setAutoreverses:YES];
    [rotateAnimation setRepeatCount:CGFLOAT_MAX];
    
    [layer addAnimation:popOutAnimation forKey:@"popOutAnimation"];
    [layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
}

+(void)animateLayerDisgust:(CALayer*)layer
{
    
}

+(void)animateLayerFear:(CALayer*)layer
{
    CABasicAnimation* shiverAnimation = [CABasicAnimation animationWithKeyPath:
                                         @"transform.translation.x"];
    [shiverAnimation setFromValue:[NSNumber numberWithFloat:-5.0]];
    [shiverAnimation setToValue:[NSNumber numberWithFloat:5.0]];
    [shiverAnimation setDuration:0.05];
    [shiverAnimation setAutoreverses:YES];
    [shiverAnimation setRepeatCount:CGFLOAT_MAX];
    
    CABasicAnimation* shrinkAnimation = [CABasicAnimation animationWithKeyPath:
                                         @"transform.scale.y"];
    [shrinkAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [shrinkAnimation setToValue:[NSNumber numberWithFloat:0.75]];
    [shrinkAnimation setDuration:2.0];
    [shrinkAnimation setAutoreverses:NO];
    [shrinkAnimation setRepeatCount:CGFLOAT_MAX];
    
    [shrinkAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    [layer addAnimation:shiverAnimation forKey:@"shiverAnimation"];
    [layer addAnimation:shrinkAnimation forKey:@"shrinkAnimation"];
}

+(void)animateLayerJoy:(CALayer*)layer
{
    int toValue = rand() % 55;
    
    CABasicAnimation* jumpAnimation = [CABasicAnimation animationWithKeyPath:
                                       @"transform.translation.y"];
    [jumpAnimation setFromValue:[NSNumber numberWithFloat:0]];
    [jumpAnimation setToValue:[NSNumber numberWithFloat:toValue]];
    [jumpAnimation setDuration:0.1];
    [jumpAnimation setAutoreverses:YES];
    [jumpAnimation setRepeatCount:1];
    
    /*CATransform3D upperRightSkewTransform = CATransform3DIdentity;
    upperRightSkewTransform.m21 = 0.05;
    upperRightSkewTransform.m12 = 0.05;
    
    CABasicAnimation* upperRightSkewAnimation = [CABasicAnimation animationWithKeyPath:
                                                 @"transform"];
    [upperRightSkewAnimation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [upperRightSkewAnimation setToValue:[NSValue valueWithCATransform3D:upperRightSkewTransform]];
    [upperRightSkewAnimation setDuration:0.3];
    [upperRightSkewAnimation setAutoreverses:YES];
    [upperRightSkewAnimation setRepeatCount:CGFLOAT_MAX];
    
    CATransform3D upperLeftSkewTransform = CATransform3DIdentity;
    upperLeftSkewTransform.m21 = -0.05;
    upperLeftSkewTransform.m12 = -0.05;
    
    CABasicAnimation* upperLeftSkewAnimation = [CABasicAnimation animationWithKeyPath:
                                                @"transform"];
    [upperLeftSkewAnimation setFromValue:[NSValue valueWithCATransform3D:upperLeftSkewTransform]];
    [upperLeftSkewAnimation setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [upperLeftSkewAnimation setDuration:0.4];
    [upperLeftSkewAnimation setAutoreverses:YES];
    [upperLeftSkewAnimation setRepeatCount:CGFLOAT_MAX];
    
    [layer addAnimation:upperRightSkewAnimation forKey:@"upperRightSkewAnimation"];
    [layer addAnimation:upperLeftSkewAnimation forKey:@"upperLeftSkewAnimation"];*/
    [layer addAnimation:jumpAnimation forKey:@"jumpAnimation"];
}

+(void)animateLayerSadness:(CALayer*)layer
{
    float duration = (float)rand()/(float)RAND_MAX + 8;
    
    CABasicAnimation* rainAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [rainAnimation setFromValue:[NSNumber numberWithInt:0.0]];
    [rainAnimation setToValue:[NSNumber numberWithInt:-1000]];
    [rainAnimation setDuration:duration];
    [layer addAnimation:rainAnimation forKey:@"rainAnimation"];
}

+(void)animateLayerSurprise:(CALayer*)layer
{
    float toValue = 1 + (float)rand()/(float)RAND_MAX;
    NSLog(@"toValue: %f", toValue);
    CABasicAnimation* shockAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [shockAnimation setFromValue:[NSNumber numberWithInt:1.0]];
    [shockAnimation setToValue:[NSNumber numberWithFloat:2.0]];
    [shockAnimation setDuration:0.1];
    [layer addAnimation:shockAnimation forKey:@"shockAnimation"];
}

@end
