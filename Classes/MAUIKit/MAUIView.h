//
//  MAUIView.h
//  MAUIKit
//
//  Created by Josh Abernathy on 1/17/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MAUIResponder.h"

typedef enum {
	MAUIViewAnimationCurveEaseInOut,
	MAUIViewAnimationCurveEaseIn,
	MAUIViewAnimationCurveEaseOut,
	MAUIViewAnimationCurveLinear,
} MAUIViewAnimationCurve;


@interface MAUIView : MAUIResponder {}

@property (nonatomic, readonly, retain) CALayer *layer;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, copy) NSArray *subviews;
@property (nonatomic, assign) __weak MAUIView *superview;
@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, assign) BOOL flattenSubviews;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) BOOL clipsToBounds;
@property (nonatomic, assign) BOOL userInteractionEnabled;

+ (Class)layerClass;

- (id)initWithFrame:(CGRect)rect;

- (void)addSubview:(MAUIView *)newSubview;
- (void)removeFromSuperview;

- (void)setNeedsLayout;
- (void)setNeedsDisplay;

- (void)layoutSubviews;
- (void)drawRect:(CGRect)rect;

- (CGPoint)convertPoint:(CGPoint)point fromView:(MAUIView *)view;
- (CGPoint)convertPoint:(CGPoint)point toView:(MAUIView *)view;
- (MAUIView *)hitTest:(CGPoint)point withEvent:(NSEvent *)event;
- (BOOL)pointInside:(CGPoint)point withEvent:(NSEvent *)event;

+ (void)beginAnimations:(NSString *)animationID context:(void *)context;
+ (void)setAnimationDuration:(CFTimeInterval)duration;
+ (void)setAnimationCurve:(MAUIViewAnimationCurve)curve;
+ (void)setAnimationCompletion:(void (^)(BOOL finished))block;
+ (void)commitAnimations;

@end
