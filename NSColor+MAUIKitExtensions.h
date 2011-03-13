//
//  NSColor+MAUIKitExtensions.h
//  MAUIKit
//
//  Created by Josh Abernathy on 3/9/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSColor (MAUIKitExtensions)

@property (nonatomic, readonly) CGColorRef CGColor;

+ (NSColor *)colorWithCGColor:(CGColorRef)CGColor;

@end
