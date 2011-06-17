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

@property (nonatomic, retain) MAUIView *buttonView1;
@property (nonatomic, retain) MAUIView *buttonView2;
@end


@implementation MAUIKitAppDelegate


#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	self.buttonView1 = [[MAUIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 140.0f, 50.0f)];
	self.buttonView1.backgroundColor = [NSColor redColor];
	self.buttonView1.layer.cornerRadius = 5.0f;
	self.buttonView1.layer.masksToBounds = YES;
	self.buttonView1.flattenSubviews = YES;
	
	MAUILabel *label1 = [[MAUILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 140.0f, 50.0f)];
	label1.text = @"Hi, I have subpixel anti-aliasing!";
	[self.buttonView1 addSubview:label1];
	
	self.buttonView2 = [[MAUIView alloc] initWithFrame:CGRectMake(10.0f, 80.0f, 140.0f, 50.0f)];
	self.buttonView2.backgroundColor = [NSColor redColor];
	self.buttonView2.layer.cornerRadius = 5.0f;
	self.buttonView2.layer.masksToBounds = YES;
	self.buttonView2.flattenSubviews = NO;
	
	MAUILabel *label2 = [[MAUILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 140.0f, 50.0f)];
	label2.text = @"Hi, I look like shit!";
	[self.buttonView2 addSubview:label2];
	
	self.nsView.rootView.backgroundColor = [NSColor lightGrayColor];
	[self.nsView.rootView addSubview:self.buttonView1];
	[self.nsView.rootView addSubview:self.buttonView2];
	
	[self performSelector:@selector(animate1) withObject:nil afterDelay:5.0f];
}


#pragma mark API

@synthesize window;
@synthesize nsView;
@synthesize buttonView1;
@synthesize buttonView2;

- (void)animate1 {
	[MAUIView beginAnimations:nil context:NULL];
	self.buttonView1.frame = CGRectMake(CGRectGetMaxX(self.nsView.rootView.bounds) - self.buttonView1.frame.size.width*2, CGRectGetMaxY(self.nsView.rootView.bounds) - self.buttonView1.frame.size.height*2, self.buttonView1.bounds.size.width, self.buttonView1.bounds.size.height);
	self.buttonView2.frame = CGRectMake(CGRectGetMaxX(self.nsView.rootView.bounds) - self.buttonView2.frame.size.width*2, CGRectGetMaxY(self.nsView.rootView.bounds) - self.buttonView2.frame.size.height, self.buttonView2.bounds.size.width, self.buttonView2.bounds.size.height);
	[MAUIView commitAnimations];
	
	[self performSelector:@selector(animate2) withObject:nil afterDelay:5.0f];
}

- (void)animate2 {
	[MAUIView beginAnimations:nil context:NULL];
	self.buttonView1.alpha = 0.0f;
	self.buttonView2.alpha = 0.0f;
	[MAUIView commitAnimations];
}

@end
