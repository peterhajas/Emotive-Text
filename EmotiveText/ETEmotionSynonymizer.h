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

#import <Foundation/Foundation.h>

#define kETAngerEmotions [NSArray arrayWithObjects:@"anger", @"agressiveness", @"agitation", @"ambivalence", @"annoyance", @"concern", @"conflict", @"confusion", @"cruelty", @"defeat", @"distemper", @"envy", @"hate", @"hostility", @"hurt", @"malevolence", nil]
#define kETDisgustEmotions [NSArray arrayWithObjects:@"disgust", @"discomfort", @"embarrassment", @"emotion", @"humiliation", nil]
#define kETFearEmotions [NSArray arrayWithObjects:@"fear", @"alienation", @"anxiety", nil]
#define kETJoyEmotions [NSArray arrayWithObjects:@"joy", @"approval", @"astonishment", @"belonging", @"benevolence", @"blessedness", @"care", @"chirk up", @"closeness", @"comfort", @"commiserate", @"compassion", @"delight", @"desire", @"elation", @"empathize", @"encouragement", @"enjoyment", @"friendliness", @"happiness", @"humor", @"laugh", @"liking", @"love", nil]
#define kETSadnessEmotions [NSArray arrayWithObjects:@"sadness", @"boredness", @"break up", @"cry", @"depression", @"devestation", @"die", @"disappointment", @"discontentment", @"distance", @"dissatisfaction", @"distress", @"express emotion", @"guilt", @"isolation", @"longing", @"pain", @"weep", @"worry", @"wound", nil]
#define kETSurpriseEmotions [NSArray arrayWithObjects:@"surprise", nil]

@interface ETEmotionSynonymizer : NSObject

+(BOOL)emotionIsAnger:(NSString*)emotion;
+(BOOL)emotionIsDisgust:(NSString*)emotion;
+(BOOL)emotionIsFear:(NSString*)emotion;
+(BOOL)emotionIsJoy:(NSString*)emotion;
+(BOOL)emotionIsSadness:(NSString*)emotion;
+(BOOL)emotionIsSurprise:(NSString*)emotion;

@end
