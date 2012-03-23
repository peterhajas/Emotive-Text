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

#import "ETAppDelegate.h"
#import "ETEmotionTextAttributer.h"

@implementation ETAppDelegate

@synthesize window = _window;
@synthesize view = _view;

-(void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    textView = [[ETTextView alloc] initWithFrame:[_view frame]];
    [_view addSubview:textView];

    ETEmotionTextAttributer* attributer = [[ETEmotionTextAttributer alloc] init];
    [attributer attributedStringForText:@"I am happy today."];
}

-(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    [textView animateText:[fieldEditor string]];
    return YES;
}

@end
