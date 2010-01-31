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
- (void) renderGrid:(GRRange)chartRange;
- (void) renderData:(GRRange)chartRange;

@end


@implementation GRLineChart

@synthesize dataProvider = _dataProvider;
@synthesize minGridX, minGridY;

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self initVars];
    }
    return self;
}

- (void) initVars
{
	_dataProviderDirty = NO;
	
	minGridX = 25;
	minGridY = 25;
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
	[self renderGrid:chartRange];
	[self renderData:chartRange];
	
	redrawChart = NO;
}

- (void) renderGrid:(GRRange)chartRange
{
	CGFloat lineDash[2];
	lineDash[0] = 5.0f;
	lineDash[1] = 5.0f;
	
	CGContextRef cgContext = UIGraphicsGetCurrentContext();
	CGContextBeginPath(cgContext);
	
	// Grid Lines
	CGContextSetLineDash(cgContext, 0.0f, lineDash, 2);
	CGContextSetLineWidth(cgContext, 0.3f);
	UIColor *gridColor = [UIColor whiteColor];
	
	// determine the grid spacing
	float gridSpaceX = xPad * ceil(minGridX / xPad);
	float gridSpaceY = yPad * ceil(minGridY / yPad);
	
	int xLines = ceil(self.frame.size.width / gridSpaceX);
	int yLines = ceil(self.frame.size.height / gridSpaceY);
	
	// Vertical grid lines
	int xPos = 0;
	int yPos = self.frame.size.height;
	for (int x = 0; x < xLines; x++)
	{
		CGContextMoveToPoint(cgContext, xPos, yPos);
		CGContextAddLineToPoint(cgContext, xPos, yPos - self.frame.size.height);
		CGContextSetStrokeColorWithColor(cgContext, gridColor.CGColor);
		
		xPos += gridSpaceX;
	}

	// Horizontal lines
	xPos = 0;
	yPos = self.frame.size.height;
	for (int y = 0; y < yLines; y++)
	{
		CGContextMoveToPoint(cgContext, xPos, yPos);
		CGContextAddLineToPoint(cgContext, xPos + self.frame.size.width, yPos);
		CGContextSetStrokeColorWithColor(cgContext, gridColor.CGColor);
		
		yPos -= gridSpaceY;
	}
	
	CGContextStrokePath(cgContext);
	UIGraphicsEndImageContext();
}

- (void) renderData:(GRRange)chartRange
{	
	GRLineSeries *firstSeries = (GRLineSeries *)[self.dataProvider objectAtIndex:0];
	int totalPoints = [firstSeries.data count];
	
	// baseline is the bottom line of the chart
	float baseline = self.frame.size.height;
	CGPoint currentPoint = CGPointMake(0, baseline);
	
	CGContextRef cgContext = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(cgContext, 1.0f);
	CGContextBeginPath(cgContext);
	CGContextSetLineDash(cgContext, 0, nil, 0);
	
	CGPoint endPoint = CGPointZero;
	int totalLines = [self.dataProvider count];
	for (int i = 0; i < totalLines; i++)
	{
		GRLineSeries *cSeries = (GRLineSeries *)[self.dataProvider objectAtIndex:i];
		for (int k = 0; k < totalPoints; k++)
		{	
			if (k == 0)
			{
				currentPoint.x = 0;
				currentPoint.y = baseline - ([[cSeries.data objectAtIndex:k] floatValue] - chartRange.min) * yPad;
				CGContextMoveToPoint(cgContext, currentPoint.x, currentPoint.y);
			}
			else
			{
				endPoint.x += xPad;
				endPoint.y = baseline - ([[cSeries.data objectAtIndex:k] floatValue] - chartRange.min) * yPad;
				CGContextAddLineToPoint(cgContext, endPoint.x, endPoint.y);
			}
		}
		CGContextSetStrokeColorWithColor(cgContext, cSeries.lineColor.CGColor);
		CGContextStrokePath(cgContext);
		endPoint = CGPointZero;
	}
	
	
	UIGraphicsEndImageContext();
}

- (GRRange) getChartRange
{
	GRLineSeries *firstSeries = (GRLineSeries *)[self.dataProvider objectAtIndex:0];
	
	float testValue = [[firstSeries.data objectAtIndex:0] floatValue];
	
	float min = testValue;
	float max = testValue;	
	
	int totalLines = [self.dataProvider count];
	for (int i = 0; i < totalLines; i++)
	{
		GRLineSeries *cSeries = (GRLineSeries *)[self.dataProvider objectAtIndex:i];
		int total = [cSeries.data count];
		for (int k = 0; k < total; k++)
		{
			testValue = [[cSeries.data objectAtIndex:k] floatValue];
			if (testValue > max)
				max = testValue;
			
			if (testValue < min)
				min = testValue;
		}
	}
	
	GRRange range;
	range.min = min;
	range.max = max;
	
	int totalPoints = [firstSeries.data count];
	xPad = round(self.frame.size.width / (totalPoints - 1));
	yPad = self.frame.size.height / (range.max - range.min);
	NSLog(@"xPad: %f", xPad);
	
	return range;
}


#pragma mark -
#pragma mark Cleanup
- (void)dealloc {
	
	[_dataProvider release];
	
    [super dealloc];
}


@end
