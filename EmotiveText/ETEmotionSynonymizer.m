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

#import "ETEmotionSynonymizer.h"

@implementation ETEmotionSynonymizer

+(BOOL)emotionIsAnger:(NSString*)emotion
{
    return [kETAngerEmotions containsObject:emotion];
}

+(BOOL)emotionIsDisgust:(NSString*)emotion
{
    return [kETDisgustEmotions containsObject:emotion];
}

+(BOOL)emotionIsFear:(NSString*)emotion
{
    return [kETFearEmotions containsObject:emotion];
}

+(BOOL)emotionIsJoy:(NSString*)emotion
{
    return [kETJoyEmotions containsObject:emotion];
}

+(BOOL)emotionIsSadness:(NSString*)emotion
{
    return [kETSadnessEmotions containsObject:emotion];
}

+(BOOL)emotionIsSurprise:(NSString*)emotion
{
    return [kETSurpriseEmotions containsObject:emotion];
}

@end
