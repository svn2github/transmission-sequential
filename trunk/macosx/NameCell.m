/******************************************************************************
 * Copyright (c) 2005 Eric Petit
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *****************************************************************************/

#include "NameCell.h"
#include "Utils.h"

@implementation NameCell

- (void) setStat: (tr_stat_t *) stat;
{
    fStat = stat;
}

- (void) drawWithFrame: (NSRect) cellFrame inView: (NSView *) view
{
    if( ![view lockFocusIfCanDraw] )
    {
        return;
    }

    NSString * nameString = NULL, * timeString = @"", * peersString = @"";
    NSMutableDictionary * attributes;
    attributes = [NSMutableDictionary dictionaryWithCapacity: 1];
    NSPoint pen = cellFrame.origin;
    
    NSString * sizeString = [NSString stringWithFormat: @" (%@)",
        stringForFileSize( fStat->info.totalSize )];

    nameString = [NSString stringWithFormat: @"%@%@",
        stringFittingInWidth( fStat->info.name, cellFrame.size.width -
                10 - widthForString( sizeString, 12 ), 12 ),
        sizeString];

    if( fStat->status & TR_STATUS_PAUSE )
    {
        timeString = [NSString stringWithFormat:
            @"Paused (%.2f %%)", 100 * fStat->progress];
        peersString = @"";
    }
    else if( fStat->status & TR_STATUS_CHECK )
    {
        timeString = [NSString stringWithFormat:
            @"Checking existing files (%.2f %%)", 100 * fStat->progress];
        peersString = @"";
    }
    else if( fStat->status & TR_STATUS_DOWNLOAD )
    {
        if( fStat->eta < 0 )
        {
            timeString = [NSString stringWithFormat:
                @"Finishing in --:--:-- (%.2f %%)", 100 * fStat->progress];
        }
        else
        {
            timeString = [NSString stringWithFormat:
                @"Finishing in %02d:%02d:%02d (%.2f %%)",
                fStat->eta / 3600, ( fStat->eta / 60 ) % 60,
                fStat->eta % 60, 100 * fStat->progress];
        }
        peersString = [NSString stringWithFormat:
            @"Downloading from %d of %d peer%s",
            fStat->peersUploading, fStat->peersTotal,
            ( fStat->peersTotal == 1 ) ? "" : "s"];
    }
    else if( fStat->status & TR_STATUS_SEED )
    {
        timeString  = [NSString stringWithFormat:
            @"Seeding, uploading to %d of %d peer%s",
            fStat->peersDownloading, fStat->peersTotal,
            ( fStat->peersTotal == 1 ) ? "" : "s"];
        peersString = @"";
    }
    else if( fStat->status & TR_STATUS_STOPPING )
    {
        timeString  = @"Stopping...";
        peersString = @"";
    }

    if( ( fStat->status & ( TR_STATUS_DOWNLOAD | TR_STATUS_SEED ) ) &&
        ( fStat->status & TR_TRACKER_ERROR ) )
    {
        peersString = [NSString stringWithFormat: @"%@%@",
    	@"Error: ", stringFittingInWidth( fStat->error,
    	    cellFrame.size.width - 15 -
    	    widthForString( @"Error: ", 10 ), 10 )];
    }

    [attributes setObject: [NSFont messageFontOfSize:12.0]
        forKey: NSFontAttributeName];

    pen.x += 5; pen.y += 5;
    [nameString drawAtPoint: pen withAttributes: attributes];

    [attributes setObject: [NSFont messageFontOfSize:10.0]
        forKey: NSFontAttributeName];

    pen.x += 5; pen.y += 20;
    [timeString drawAtPoint: pen withAttributes: attributes];

    pen.x += 0; pen.y += 15;
    [peersString drawAtPoint: pen withAttributes: attributes];

    /* "Reveal in Finder" button */
    fRevealRect = NSMakeRect( cellFrame.origin.x + cellFrame.size.width - 19,
                              cellFrame.origin.y + cellFrame.size.height - 19,
                              14, 14 );
    NSImage * revealImage;
    if( NSPointInRect( fClickPoint, fRevealRect ) )
    {
        revealImage = [NSImage imageNamed: @"RevealOn.tiff"];
    }
    else
    {
        revealImage = [NSImage imageNamed: @"RevealOff.tiff"];
    }
    pen.x = fRevealRect.origin.x;
    pen.y = fRevealRect.origin.y + 14;
    [revealImage compositeToPoint: pen operation: NSCompositeSourceOver];

    [view unlockFocus];
}

/* Track mouse as long as button is down */
- (BOOL) startTrackingAt: (NSPoint) start inView: (NSView *) v
{
    fClickPoint = start;
    return YES;
}
- (BOOL) continueTracking: (NSPoint) last at: (NSPoint) current
    inView: (NSView *) v
{
    fClickPoint = current;
    return YES;
}

- (void) stopTracking: (NSPoint) last at:(NSPoint) stop
    inView: (NSView *) v mouseIsUp: (BOOL) flag
{
    if( flag && NSPointInRect( stop, fRevealRect ) )
    {
        /* Reveal in Finder */
        [[NSWorkspace sharedWorkspace] openFile:
            [NSString stringWithUTF8String: fStat->folder]];
    }
    fClickPoint = NSMakePoint(0,0);
}

@end
