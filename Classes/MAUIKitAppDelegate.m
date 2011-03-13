//
//  MAUIKitAppDelegate.m
//  MAUIKit
//
//  Created by Josh Abernathy on 1/17/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "MAUIKitAppDelegate.h"
#import "MAUIView.h"
#import "MAUILabel.h"
#import "MAUINSView.h"

@interface MAUIKitAppDelegate ()
- (void)animate1;
- (void)animate2;

@property (nonatomic, retain) MAUIView *buttonView;
@end


@implementation MAUIKitAppDelegate


#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	self.buttonView = [[MAUIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 120.0f, 50.0f)];
	self.buttonView.backgroundColor = [NSColor redColor];
	self.buttonView.layer.cornerRadius = 5.0f;
	self.buttonView.layer.masksToBounds = YES;
	
	MAUILabel *label = [[MAUILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 120.0f, 50.0f)];
	label.text = @"this is a test, eh?";
	[self.buttonView addSubview:label];
	
	self.buttonView.flattenSubviews = YES;
	
	self.nsView.rootView.backgroundColor = [NSColor lightGrayColor];
	[self.nsView.rootView addSubview:self.buttonView];
	[self.nsView.rootView setNeedsDisplay];
	
	[self performSelector:@selector(animate1) withObject:nil afterDelay:5.0f];
}


#pragma mark API

@synthesize window;
@synthesize nsView;
@synthesize buttonView;

- (void)animate1 {
	[MAUIView beginAnimations:nil context:NULL];
	self.buttonView.frame = CGRectMake(CGRectGetMaxX(self.nsView.rootView.bounds) - self.buttonView.frame.size.width*2, CGRectGetMaxY(self.nsView.rootView.bounds) - self.buttonView.frame.size.height*2, 120.0f, 50.0f);
	[MAUIView commitAnimations];
	
	[self performSelector:@selector(animate2) withObject:nil afterDelay:5.0f];
}

- (void)animate2 {
	[MAUIView beginAnimations:nil context:NULL];
	self.buttonView.alpha = 0.0f;
	[MAUIView commitAnimations];
}

@end
