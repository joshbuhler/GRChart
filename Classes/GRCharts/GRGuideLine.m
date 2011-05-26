//
//  GRGuideLine.m
//  GRCharts
//
//  Created by Joshua Buhler on 5/26/11.
//  Copyright 2011 Rain. All rights reserved.
//

#import "GRGuideLine.h"


@implementation GRGuideLine

@synthesize lineColor, value, orientation, needsRedraw;

- (id)init {
    self = [super init];
    if (self) {
        self.lineColor = [UIColor whiteColor];
        value = 0;
        orientation = GUIDELINE_VERTICAL;
        needsRedraw = NO;
    }
    return self;
}

- (void) setLineColor:(UIColor *)newLineColor
{
    [lineColor release];
    lineColor = [newLineColor retain];
    needsRedraw = YES;
}

- (void) setValue:(float)newValue
{
    value = newValue;
    needsRedraw = YES;
}

- (void) setOrientation:(int)newValue
{
    orientation = newValue;
    needsRedraw = YES;
}


- (void)dealloc {
    
    [lineColor release];
    
    [super dealloc];
}

@end
