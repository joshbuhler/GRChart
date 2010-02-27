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
- (void) calcChartArea:(GRRange)chartRange;
- (void) renderGrid:(GRRange)chartRange;
- (void) renderData:(GRRange)chartRange;
- (void) renderLabels:(GRRange)chartRange;

@end


@implementation GRLineChart

@synthesize dataProvider = _dataProvider;
@synthesize minGridX, minGridY;
@synthesize yFormatter, xFormatter;
@synthesize chartTitle;

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
	
	chartFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	
	minGridX = 25;
	minGridY = 25;
	
	labelXPad = 5;
	labelYPad = 5;
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
	[self calcChartArea:chartRange];
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
	[gridColor set];
	
	// determine the grid spacing
	float gridSpaceX = xPad * ceil(minGridX / xPad);
	float gridSpaceY = yPad * ceil(minGridY / yPad);
	
	int xLines = ceil(chartFrame.size.width / gridSpaceX);
	int yLines = ceil(chartFrame.size.height / gridSpaceY);
	
	// X-axis grid lines
	float xPos = chartFrame.origin.x;
	float yPos = chartFrame.origin.y + chartFrame.size.height;
	for (int x = 0; x < xLines; x++)
	{
		CGContextMoveToPoint(cgContext, xPos, yPos);
		CGContextAddLineToPoint(cgContext, xPos, yPos - chartFrame.size.height);
		CGContextSetStrokeColorWithColor(cgContext, gridColor.CGColor);
		
		xPos += gridSpaceX;
	}

	// Y-Axis lines
	xPos = chartFrame.origin.x;
	yPos = chartFrame.origin.y + chartFrame.size.height;
	for (int y = 0; y < yLines; y++)
	{
		CGContextMoveToPoint(cgContext, xPos, yPos);
		CGContextAddLineToPoint(cgContext, xPos + chartFrame.size.width, yPos);
		CGContextSetStrokeColorWithColor(cgContext, gridColor.CGColor);
		BOOL renderLabels = YES;
		if (renderLabels)
		{
			float yValue = ((float)y / (float)yLines) * (chartRange.max - chartRange.min);
			
			NSString *labelString;
			if (yFormatter != nil)
			{
				labelString = [yFormatter stringForObjectValue:[NSNumber numberWithFloat:yValue]];
			}
			else
			{
				labelString = [[NSNumber numberWithFloat:yValue] stringValue];
			}

			CGSize labelSize = [labelString sizeWithFont:[UIFont fontWithName:@"Arial" size:10]];
			[gridColor set];
			
			float labelY = (y == 0) ? yPos - labelSize.height : yPos - (labelSize.height / 2);
			
			[labelString drawInRect:CGRectMake(0, labelY, labelSize.width, labelSize.height)
						   withFont:[UIFont fontWithName:@"Arial" size:10]];
			
			// draw the top label
			if (y == (yLines - 1))
			{
				if (yFormatter != nil)
				{
					labelString = [yFormatter stringForObjectValue:[NSNumber numberWithFloat:chartRange.max]];
				}
				else
				{
					labelString = [[NSNumber numberWithFloat:chartRange.max] stringValue];
				}
				
				labelSize = [labelString sizeWithFont:[UIFont fontWithName:@"Arial" size:10]];
				yPos = chartFrame.origin.y;
				[labelString drawInRect:CGRectMake(0, yPos, labelSize.width, labelSize.height)
							   withFont:[UIFont fontWithName:@"Arial" size:10]];
			}
		}
		
		yPos -= gridSpaceY;
		
		if (y == (yLines - 1))
		{
			CGContextMoveToPoint(cgContext, xPos, chartFrame.origin.y);
			CGContextAddLineToPoint(cgContext, xPos + chartFrame.size.width, chartFrame.origin.y);
			CGContextSetStrokeColorWithColor(cgContext, gridColor.CGColor);
		}
	}
	
	CGContextStrokePath(cgContext);
	UIGraphicsEndImageContext();
}

- (void) renderData:(GRRange)chartRange
{	
	GRLineSeries *firstSeries = (GRLineSeries *)[self.dataProvider objectAtIndex:0];
	int totalPoints = [firstSeries.data count];
	
	// baseline is the bottom line of the chart
	float baseline = chartFrame.origin.y + chartFrame.size.height;
	CGPoint currentPoint = CGPointMake(chartFrame.origin.x, baseline);
	
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
			NSObject *cObj = [cSeries.data objectAtIndex:k];
			float pointValue;
			
			if (cSeries.yField != nil)
			{
				pointValue = [[(NSDictionary *)cObj objectForKey:cSeries.yField] floatValue];
			}
			else
			{
				pointValue = [(NSNumber *)cObj floatValue];
			}
			
			if (k == 0)
			{
				currentPoint.x = chartFrame.origin.x;
				currentPoint.y = baseline - (pointValue - chartRange.min) * yPad;
				CGContextMoveToPoint(cgContext, currentPoint.x, currentPoint.y);
			}
			else
			{
				endPoint.x += xPad;
				endPoint.y = baseline - (pointValue - chartRange.min) * yPad;
				CGContextAddLineToPoint(cgContext, endPoint.x, endPoint.y);
			}
		}
		CGContextSetStrokeColorWithColor(cgContext, cSeries.lineColor.CGColor);
		CGContextStrokePath(cgContext);
		endPoint = CGPointZero;
	}
	
	UIGraphicsEndImageContext();
}

- (void) calcChartArea:(GRRange)chartRange
{
	// if we're rendering labels, adjust the grid frame to make room for them
	BOOL renderLabels = YES;
	if (renderLabels)
	{
		NSString *labelString;
		if (yFormatter != nil)
		{
			labelString = [yFormatter stringForObjectValue:[NSNumber numberWithFloat:chartRange.max]];
		}
		else
		{
			labelString = [[NSNumber numberWithFloat:chartRange.max] stringValue];
		}
		
		CGSize labelSize = [labelString sizeWithFont:[UIFont fontWithName:@"Arial" size:10]];
		chartFrame.origin.x += (labelSize.width + labelXPad);
	}
	
	// if there's a title, adjust the grid for that
	if (chartTitle != nil)
	{
		CGSize labelSize = [chartTitle sizeWithFont:[UIFont fontWithName:@"Arial" size:14]];
		chartFrame.origin.y += (labelSize.height + labelYPad);
		chartFrame.size.height -= (labelSize.height + labelYPad);
		
		UIColor *labelColor = [UIColor whiteColor];
		[labelColor set];
		
		[chartTitle drawInRect:CGRectMake((self.frame.size.width / 2) - (labelSize.width / 2), 0, labelSize.width, labelSize.height)
					  withFont:[UIFont fontWithName:@"Arial" size:14]
				 lineBreakMode:UILineBreakModeTailTruncation
					 alignment:UITextAlignmentCenter];
	}
	
	// this figures out the spacing of the datapoints so they can be evenly distributed across the grid
	GRLineSeries *firstSeries = (GRLineSeries *)[self.dataProvider objectAtIndex:0];
	int totalPoints = [firstSeries.data count];
	xPad = (chartFrame.size.width / (totalPoints - 1));
	yPad = chartFrame.size.height / (chartRange.max - chartRange.min);
}

- (GRRange) getChartRange
{
	NSMutableArray *maxValues = [[NSMutableArray alloc] init];
	NSMutableArray *minValues = [[NSMutableArray alloc] init];
	
	int totalLines = [self.dataProvider count];
	for (int i = 0; i < totalLines; i++)
	{
		GRLineSeries *cSeries = (GRLineSeries *)[self.dataProvider objectAtIndex:i];

		if (cSeries.yField != nil)
		{
			[maxValues addObject:[cSeries.data valueForKeyPath:[NSString stringWithFormat:@"@max.%@", cSeries.yField]]];
			[minValues addObject:[cSeries.data valueForKeyPath:[NSString stringWithFormat:@"@min.%@", cSeries.yField]]];
		}
		else
		{
			[maxValues addObject:[cSeries.data valueForKeyPath:@"@max.floatValue"]];
			[minValues addObject:[cSeries.data valueForKeyPath:@"@min.floatValue"]];
		}
	}
	
	GRRange range;
	range.min = [[minValues valueForKeyPath:@"@min.floatValue"] floatValue];
	range.max = [[maxValues valueForKeyPath:@"@max.floatValue"] floatValue];
	
	return range;
}


#pragma mark -
#pragma mark Cleanup
- (void)dealloc {
	
	[_dataProvider release];
	
    [super dealloc];
}


@end
