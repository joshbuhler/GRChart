//
//  GRLineSeries.m
//  GRCharts
//
//  Created by Joshua Buhler on 1/30/10.
//  Copyright 2010 Rain. All rights reserved.
//

#import "GRLineSeries.h"


@implementation GRLineSeries

@synthesize data;
@synthesize lineColor;

- (id) initWithData:(NSArray *)lineData andColor:(UIColor *)color
{
	self = [super init];
	
	self.data = lineData;
	self.lineColor = color;
	
	return self;
}


@end
