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

#import <Cocoa/Cocoa.h>
#import <transmission.h>

@interface PrefsController : NSObject

{
    tr_handle_t * fHandle;
    
    IBOutlet NSPanel        * fPrefsWindow;
    NSToolbar               * fToolbar;
    IBOutlet NSView         * fGeneralView, * fTransfersView,
                            * fNetworkView, * fBlankView;
    
    IBOutlet NSPopUpButton  * fFolderPopUp;
    IBOutlet NSButton       * fQuitCheck, * fRemoveCheck,
                            * fBadgeDownloadRateCheck, * fBadgeUploadRateCheck,
                            * fAutoStartCheck;                           
    IBOutlet NSPopUpButton  * fUpdatePopUp;

    IBOutlet NSTextField    * fPortField;
    IBOutlet NSButton       * fUploadCheck;
    IBOutlet NSTextField    * fUploadField;
    IBOutlet NSButton       * fDownloadCheck;
    IBOutlet NSTextField    * fDownloadField;
    IBOutlet NSButton       * fRatioCheck;
    IBOutlet NSTextField    * fRatioField;
    
    IBOutlet NSMenu         * fUploadMenu, * fDownloadMenu;
    IBOutlet NSMenuItem     * fUploadLimitItem, * fUploadNoLimitItem,
                            * fDownloadLimitItem, * fDownloadNoLimitItem,
                            * fRatioSetItem, * fRatioNotSetItem;
    
    IBOutlet NSWindow       * fWindow;

    NSString                * fDownloadFolder;
    NSUserDefaults          * fDefaults;
}

- (void) setPrefsWindow: (tr_handle_t *) handle;

- (void) setShowMessage:        (id) sender;
- (void) setBadge:              (id) sender;
- (void) setUpdate:             (id) sender;
- (void) setAutoStart:          (id) sender;
- (void) setDownloadLocation:   (id) sender;
- (void) folderSheetShow:       (id) sender;

- (void) setPort:               (id) sender;
- (void) setLimitCheck:         (id) sender;
- (void) setLimit:              (id) sender;
- (void) setLimitMenu:          (id) sender;
- (void) setQuickSpeed:         (id) sender;

- (void) setRatio:              (id) sender;
- (void) setRatioCheck:			(id) sender;
- (void) setRatioMenu:          (id) sender;
- (void) setQuickRatio:         (id) sender;

@end
