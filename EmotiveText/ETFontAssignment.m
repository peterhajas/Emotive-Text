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

#import "ETFontAssignment.h"
#import "ETTextView.h"
#import "ETEmotionSynonymizer.h"

@implementation ETFontAssignment

+(NSFont*)fontForEmotion:(NSString*)emotion
{
    return [NSFont fontWithName:[ETFontAssignment fontNameForEmotion:emotion]
                           size:ETTextPointSize];
}

+(NSString*)fontNameForEmotion:(NSString*)emotion
{
    if([ETEmotionSynonymizer emotionIsAnger:emotion])
    {
        return @"Chalkboard";
    }
    else if([ETEmotionSynonymizer emotionIsDisgust:emotion])
    {
        return @"Baskerville";
    }
    else if([ETEmotionSynonymizer emotionIsFear:emotion])
    {
        return @"Futura";
    }
    else if([ETEmotionSynonymizer emotionIsJoy:emotion])
    {
        return @"Impact";
    }
    else if([ETEmotionSynonymizer emotionIsSadness:emotion])
    {
        return @"Comic Sans MS";
    }
    else if([ETEmotionSynonymizer emotionIsSurprise:emotion])
    {
        return @"Times New Roman";
    }
    else
    {
        return @"Helvetica";
    }
}

@end
