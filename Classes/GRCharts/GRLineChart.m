//
//  GRLineChart.m
//  GRCharts
//
//  Created by Joshua Buhler on 1/23/10.
//  Copyright (c) 2010 Josh Buhler - ghostRadio.net
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
	float xPad = self.frame.size.width / totalPoints;
	float yPad = self.frame.size.height / (chartRange.max - chartRange.min);
	NSLog(@"xPad: %f yPad: %f", xPad, yPad);
	
	float baseline = self.frame.size.height;
	CGPoint currentPoint = CGPointMake(0, baseline);
	
	currentPoint.y = baseline - ([[_dataProvider objectAtIndex:0] floatValue] - chartRange.min) * yPad;
		
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextBeginPath(c);
	
	CGContextMoveToPoint(c, currentPoint.x, currentPoint.y);
	
	CGPoint endPoint = CGPointZero;
	for (int i = 1; i < totalPoints; i++)
	{	
		endPoint.x += xPad;
		endPoint.y = baseline - ([[_dataProvider objectAtIndex:i] floatValue] - chartRange.min) * yPad;
		
		
		CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
		//CGContextClosePath(c);
		
		CGContextSetStrokeColorWithColor(c, [UIColor orangeColor].CGColor);
		
	}
	CGContextStrokePath(c);
	
	UIGraphicsEndImageContext();
	
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
