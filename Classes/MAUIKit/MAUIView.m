//
//  MAUIView.m
//  MAUIKit
//
//  Created by Josh Abernathy on 1/17/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "MAUIView.h"

static NSMutableArray *animationStack = nil;

@interface MAUIView ()
@property (nonatomic, retain) CALayer *layer;
@property (nonatomic, assign) BOOL manuallyDrawingIntoSuperview;
@end


@implementation MAUIView


#pragma mark CALayerDelegate

- (void)layoutSublayersOfLayer:(CALayer *)inLayer {
	[self layoutSubviews];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
	// If a superview is flattening its subviews then those subviews are actually hidden. But we still want to draw if we're compositing the view into its superview.
	if(self.layer.hidden && !self.manuallyDrawingIntoSuperview) return;
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:YES]];
	
	[self drawRect:self.layer.bounds];
	
	if(self.flattenSubviews) {
		for(MAUIView *subview in self.subviews) {
			[NSGraphicsContext saveGraphicsState];
			
			NSAffineTransform *transform = [NSAffineTransform transform];
			[transform translateXBy:subview.frame.origin.x yBy:subview.frame.origin.y];
			[transform concat];
			
			CGContextRef cgContext = [[NSGraphicsContext currentContext] graphicsPort];
			if(subview.clipsToBounds) {
				CGContextClipToRect(cgContext, subview.frame);
			}
			
			subview.layer.hidden = YES;
			subview.manuallyDrawingIntoSuperview = YES;
			[subview.layer drawInContext:cgContext];
			subview.manuallyDrawingIntoSuperview = NO;
			
			[NSGraphicsContext restoreGraphicsState];
		}
	}
	
	[NSGraphicsContext restoreGraphicsState];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key {
	if(animationStack.count > 0) {
		return [animationStack lastObject];
	} else {
		return (id) [NSNull null];
	}
}


#pragma mark API

@synthesize layer;
@synthesize subviews;
@synthesize superview;
@synthesize flattenSubviews;
@synthesize manuallyDrawingIntoSuperview;
@synthesize userInteractionEnabled;
@synthesize backgroundColor;

+ (void)initialize {
	if(self == [MAUIView class]) {
		animationStack = [NSMutableArray array];
	}
}

+ (Class)layerClass {
	return [CALayer class];
}

- (id)initWithFrame:(CGRect)rect {
	self = [super init];
	if(self == nil) return nil;
	
	self.layer = [[[self class] layerClass] layer];
	self.layer.needsDisplayOnBoundsChange = YES;
	self.layer.delegate = self;
	self.frame = rect;
	
	self.userInteractionEnabled = YES;
	
	[self setNeedsDisplay];
	
	return self;
}

- (void)addSubview:(MAUIView *)newSubview {
	if(self.subviews == nil) self.subviews = [NSArray array];
	self.subviews = [self.subviews arrayByAddingObject:newSubview];
}

- (void)removeFromSuperview {
	NSMutableArray *newSubviews = [self.superview.subviews mutableCopy];
	[newSubviews removeObject:self];
	self.superview.subviews = newSubviews;
	self.superview = nil;
	
	[self.layer removeFromSuperlayer];
}

- (void)setSubviews:(NSArray *)newSubviews {
	subviews = newSubviews;
	
	NSMutableArray *newSublayers = [NSMutableArray array];
	for(MAUIView *subview in self.subviews) {
		subview.superview = self;
		[newSublayers addObject:subview.layer];
	}
	
	self.layer.sublayers = newSublayers;
}

- (void)setFrame:(CGRect)newFrame {
	self.layer.frame = newFrame;
}

- (CGRect)frame {
	return self.layer.frame;
}

- (void)setBounds:(CGRect)newBounds {
	self.layer.bounds = newBounds;
}

- (CGRect)bounds {
	return self.layer.bounds;
}

- (void)setNeedsLayout {
	[self.layer setNeedsLayout];
}

- (void)setNeedsDisplay {
	[self.layer setNeedsDisplay];
}

- (void)layoutSubviews {
	
}

- (void)drawRect:(CGRect)dirtyRect {
	[self.backgroundColor set];
	NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
}

- (CGFloat)alpha {
	return self.layer.opacity;
}

- (void)setAlpha:(CGFloat)newAlpha {
	self.layer.opacity = newAlpha;
}

- (BOOL)clipsToBounds {
	return self.layer.masksToBounds;
}

- (void)setClipsToBounds:(BOOL)clips {
	self.layer.masksToBounds = clips;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p> frame: %@", NSStringFromClass([self class]), self, NSStringFromRect(NSRectFromCGRect(self.frame))];
}


#pragma mark Event handling

- (BOOL)isDescendantOfView:(MAUIView *)view {
	MAUIView *parent = self.superview;
	while(parent != nil && parent != view) {
		parent = parent.superview;
	}
	
	return parent != nil;
}

- (CGPoint)convertPoint:(CGPoint)point fromView:(MAUIView *)view {
	return [self.layer convertPoint:point fromLayer:view.layer];
}

- (CGPoint)convertPoint:(CGPoint)point toView:(MAUIView *)view {
	return [self.layer convertPoint:point toLayer:view.layer];
}

- (MAUIView *)hitTest:(CGPoint)point withEvent:(NSEvent *)event {
	if([self pointInside:point withEvent:event] && self.userInteractionEnabled && self.alpha > 0.1f) {
		for(MAUIView *subview in [self.subviews reverseObjectEnumerator]) {
			if(subview.userInteractionEnabled && subview.alpha > 0.1f) {
				CGPoint subviewPoint = [self convertPoint:point toView:subview];
				MAUIView *resultView = [subview hitTest:subviewPoint withEvent:event];
				if(resultView != nil) {
					return resultView;
				}
			}
		}
		
		return self;
	} else {
		return nil;
	}
}

- (BOOL)pointInside:(CGPoint)point withEvent:(NSEvent *)event {
	return CGRectContainsPoint(self.bounds, point);
}

#pragma mark Animations

+ (void)beginAnimations:(NSString *)animationID context:(void *)context {
	CABasicAnimation *animation = [CABasicAnimation animation];
	[animationStack addObject:animation];
	
	[CATransaction begin];
}

+ (void)setAnimationDuration:(CFTimeInterval)duration {
	CABasicAnimation *animation = [animationStack lastObject];
	animation.duration = duration;
}

+ (void)setAnimationCurve:(MAUIViewAnimationCurve)curve {
	CABasicAnimation *animation = [animationStack lastObject];
	
	NSString *timingFunctionName = nil;
	if(curve == MAUIViewAnimationCurveEaseInOut) {
		timingFunctionName = kCAMediaTimingFunctionEaseInEaseOut;
	} else if(curve == MAUIViewAnimationCurveEaseIn) {
		timingFunctionName = kCAMediaTimingFunctionEaseIn;
	} else if(curve == MAUIViewAnimationCurveEaseOut) {
		timingFunctionName = kCAMediaTimingFunctionEaseOut;
	} else if(curve == MAUIViewAnimationCurveLinear) {
		timingFunctionName = kCAMediaTimingFunctionLinear;
	} else {
		timingFunctionName = kCAMediaTimingFunctionDefault;
	}
	
	animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
}

+ (void)setAnimationCompletion:(void (^)(BOOL finished))block {
	[CATransaction setCompletionBlock:^{
		block(YES);
	}];
}

+ (void)commitAnimations {
	[CATransaction commit];
	
	[animationStack removeLastObject];
}

@end
