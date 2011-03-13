//
//  NSColor+MAUIKitExtensions.m
//  MAUIKit
//
//  Created by Josh Abernathy on 3/9/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "NSColor+MAUIKitExtensions.h"


@implementation NSColor (MAUIKitExtensions)

- (CGColorRef)CGColor {
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
    NSInteger componentCount = [self numberOfComponents];
    CGFloat *components = (CGFloat *)calloc(componentCount, sizeof(CGFloat));
    [self getComponents:components];
    CGColorRef color = (CGColorRef) NSMakeCollectable((id) CGColorCreate(colorSpace, components));
    free(components);
    return color;
}

+ (NSColor *)colorWithCGColor:(CGColorRef)CGColor {
    if(CGColor == NULL) return nil;
	
    return [NSColor colorWithCIColor:[CIColor colorWithCGColor:CGColor]];
}

@end
