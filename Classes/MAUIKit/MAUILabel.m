//
//  MAUILabel.m
//  MAUIKit
//
//  Created by Josh Abernathy on 1/26/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "MAUILabel.h"

@interface MAUILabel ()
- (NSDictionary *)currentAttributes;
@end


@implementation MAUILabel


#pragma mark MAUIView

- (void)drawRect:(CGRect)rect {
	[self.text drawInRect:NSRectFromCGRect(self.bounds) withAttributes:[self currentAttributes]];
}


#pragma mark API

@synthesize text;

- (NSDictionary *)currentAttributes {
	return [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Lucida Grande" size:14.0f], NSFontAttributeName, nil];
}

@end
