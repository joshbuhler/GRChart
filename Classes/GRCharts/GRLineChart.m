//
//  GRLineChart.m
//  MW2Stats
//
//  Created by Joshua Buhler on 1/23/10.
//  Copyright 2010 Rain. All rights reserved.
//

#import "GRLineChart.h"

@interface GRLineChart (PrivateMethods)

- (void) initVars;
- (void) commitProperties;

@end


@implementation GRLineChart

@synthesize dataProvider = _dataProvider;

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void) initVars
{
	_dataProviderDirty = NO;
}

#pragma mark -
#pragma mark Properties
//- (void) setDataProvider:(id GRDataProvider)value
- (void) setDataProvider:(NSArray *)value
{
	if (_dataProvider != nil)
		[_dataProvider release];
	
	_dataProvider = value;
	[_dataProvider retain];
	
	
	_dataProviderDirty = YES;
	[self commitProperties];
}

- (void) commitProperties
{
	if (_dataProviderDirty)
	{
		redrawChart = YES;
		_dataProviderDirty = NO;
	}
	
}

#pragma mark -
#pragma mark Drawing



- (void)drawRect:(CGRect)rect {
    // Drawing code
	if (!redrawChart)
		return;
	
	GRRange chartRange = [self getChartRange];
	NSLog(@"Chart range: %f-%f", chartRange.min, chartRange.max);
	
	int totalPoints = [self.dataProvider count];
	
	// how big is the chart frame, and then space the points evenly across that area
	int xPad = self.frame.size.width / (totalPoints - 1);
	int yPad = (chartRange.max - chartRange.min) / (totalPoints - 1);
	
	
	redrawChart = NO;
}

- (GRRange) getChartRange
{
	float testValue = [[self.dataProvider objectAtIndex:0] floatValue];
	
	float min = testValue;
	float max = testValue;	
	
	int total = [self.dataProvider count];
	for (int i = 0; i < total; i++)
	{
		testValue = [[self.dataProvider objectAtIndex:i] floatValue];
		if (testValue > max)
			max = testValue;
		
		if (testValue < min)
			min = testValue;
		
			
	}

	
	GRRange range;
	range.min = min;
	range.max = max;
	
	return range;
}


#pragma mark -
#pragma mark Cleanup
- (void)dealloc {
	
	[_dataProvider release];
	
    [super dealloc];
}


@end
