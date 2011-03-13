//
//  MAUIKitAppDelegate.h
//  MAUIKit
//
//  Created by Josh Abernathy on 1/17/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MAUINSView;


@interface MAUIKitAppDelegate : NSObject <NSApplicationDelegate> {}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet MAUINSView *nsView;

@end
