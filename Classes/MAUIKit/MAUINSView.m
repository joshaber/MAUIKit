//
//  MAUINSView.m
//  MAUIKit
//
//  Created by Josh Abernathy on 1/24/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "MAUINSView.h"
#import "MAUIView.h"

@interface MAUINSView ()
- (MAUIView *)realHitTest:(CGPoint)point;
- (void)setupLayer;

@property (nonatomic, retain) MAUIView *viewToReceiveEvent;
@end


@implementation MAUINSView

- (void)awakeFromNib {
	[self setupLayer];
}


#pragma mark NSResponder

- (NSView *)hitTest:(NSPoint)point {
	if(NSPointInRect(point, self.frame)) {
		self.viewToReceiveEvent = [self realHitTest:NSPointToCGPoint(point)];
		NSLog(@"%@", self.viewToReceiveEvent);
		
		return self;
	} else {
		return [super hitTest:point];
	}
}

- (void)mouseDown:(NSEvent *)event {	
	[self.viewToReceiveEvent mouseDown:event];
}

- (void)mouseUp:(NSEvent *)event {
	[self.viewToReceiveEvent mouseUp:event];
}


#pragma mark NSView

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if(self == nil) return nil;
	
	[self setupLayer];
	
	return self;
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	
	self.rootView.frame = NSRectToCGRect(frameRect);
}


#pragma mark API

@synthesize rootView;
@synthesize viewToReceiveEvent;

- (void)setupLayer {
	self.layer = [CALayer layer];
	[self setWantsLayer:YES];
	self.layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	self.layer.geometryFlipped = YES; 
}

- (MAUIView *)realHitTest:(CGPoint)point {
	CGPoint realPoint = [self.layer convertPoint:point toLayer:self.rootView.layer];
	realPoint.y = self.bounds.size.height - realPoint.y;
	return [self.rootView hitTest:realPoint withEvent:[self.window currentEvent]];
}

- (void)setRootView:(MAUIView *)newRootView {
	rootView = newRootView;
	
	[self.layer addSublayer:self.rootView.layer];
}

- (MAUIView *)rootView {
	if(rootView == nil) {
		self.rootView = [[MAUIView alloc] initWithFrame:self.layer.bounds];
	}
	
	return rootView;
}

@end
