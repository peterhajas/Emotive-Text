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

@implementation ETAnimationAssignment

+(void)animateLayer:(CALayer*)layer forEmotion:(NSString*)emotion
{
    //[layer setAnchorPoint:CGPointMake(layer.frame.size.width/2,
      //                                layer.frame.size.height/2)];
    
    CGRect oldFrame = [layer frame];
    [layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [layer setFrame:oldFrame];
    
    [layer removeAllAnimations];
    
    if([emotion isEqualToString:@"anger"])
    {
        [ETAnimationAssignment animateLayerAnger:layer];
    }
    else if([emotion isEqualToString:@"disgust"])
    {
        [ETAnimationAssignment animateLayerDisgust:layer];
    }
    else if([emotion isEqualToString:@"fear"])
    {
        [ETAnimationAssignment animateLayerFear:layer];
    }
    else if([emotion isEqualToString:@"joy"])
    {
        [ETAnimationAssignment animateLayerJoy:layer];
    }
    else if([emotion isEqualToString:@"sadness"])
    {
        [ETAnimationAssignment animateLayerSadness:layer];
    }
    else if([emotion isEqualToString:@"surprise"])
    {
        [ETAnimationAssignment animateLayerSurprise:layer];
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
    CABasicAnimation* jumpAnimation = [CABasicAnimation animationWithKeyPath:
                                       @"transform.translation.y"];
    [jumpAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
    [jumpAnimation setToValue:[NSNumber numberWithFloat:50.0]];
    [jumpAnimation setDuration:0.2];
    [jumpAnimation setAutoreverses:YES];
    [jumpAnimation setRepeatCount:CGFLOAT_MAX];
    
    CATransform3D upperRightSkewTransform = CATransform3DIdentity;
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
    [layer addAnimation:upperLeftSkewAnimation forKey:@"upperLeftSkewAnimation"];
    [layer addAnimation:jumpAnimation forKey:@"jumpAnimation"];
}

+(void)animateLayerSadness:(CALayer*)layer
{
    
}

+(void)animateLayerSurprise:(CALayer*)layer
{
    
}

@end
