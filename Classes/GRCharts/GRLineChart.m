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
- (void) calcChartArea;
- (void) renderGrid;
- (void) renderData;
- (void) renderLabels;
- (void) renderGuides;
- (float) axisYForValue:(float)value;
- (float) axisXForValue:(float)value;
@end


@implementation GRLineChart

@synthesize dataProvider = _dataProvider;
@synthesize minGridX, minGridY;
@synthesize yFormatter, xFormatter;
@synthesize chartTitle;
@synthesize guideLines;
@synthesize overrideRange;
@synthesize xGridColor, yGridColor;
@synthesize drawXLabels, drawYLabels;
@synthesize yLabelOffset;
@synthesize dashedGridLines;

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self initVars];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initVars];
    }
    return self;
}

- (void) initVars
{
	_dataProviderDirty = NO;
    _guidelinesDirty = NO;
    
    redrawChart = NO;
    redrawGuides = NO;
	
	chartFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	
	minGridX = 25;
	minGridY = 25;
	
	labelXPad = 5;
	labelYPad = 5;
    
    self.xGridColor = [UIColor whiteColor];
    self.yGridColor = [UIColor whiteColor];
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

- (void) setGuideLines:(NSMutableArray *)value
{
    [guideLines release];
    
    guideLines = [value retain];
    
    _guidelinesDirty = YES;
    [self commitProperties];
}

- (void) commitProperties
{
	if (_dataProviderDirty)
	{
		redrawChart = YES;
		_dataProviderDirty = NO;
	}
    
    if (_guidelinesDirty)
    {
        redrawGuides = YES;
        _guidelinesDirty = NO;
    }
    
    if (redrawChart || redrawGuides)
        [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Drawing



- (void)drawRect:(CGRect)rect
{
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextClearRect(cgContext, self.frame);
    
    chartFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    // no need to continue if there isn't any data
    if (_dataProvider == nil)
        return;
    
    [self getChartRange];
    [self calcChartArea];
    
//    // Drawing code
//	if (redrawChart)
//    {
        [self renderData];
        [self renderGrid];
        redrawChart = NO;
//    }
//    
//    if (redrawGuides)
//    {
        [self renderGuides];
        redrawGuides = NO;
//    }
    
    // draw the frame around the chart
    CGContextSetShadowWithColor(cgContext, CGSizeMake(3, 3), 4.0f, [UIColor blackColor].CGColor); // using this version to better control the alpha of the shadow
    CGContextBeginPath(cgContext);
    CGContextSetLineDash(cgContext, 0, nil, 0);
    UIColor *frameColor = [UIColor colorWithRed:.61f green:.61f blue:.61f alpha:1.0f];
    CGContextSetStrokeColorWithColor(cgContext, frameColor.CGColor);
    CGContextSetLineWidth(cgContext, 3.0f);
    
    CGContextStrokeRect(cgContext, chartFrame);
}

- (void) renderGrid
{
	CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    // draw in the background
    CGContextSetFillColorWithColor(cgContext, [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f].CGColor);
    CGContextFillRect(cgContext, chartFrame);
    
    //
	CGContextBeginPath(cgContext);
	
	// Grid Lines
    
    if (dashedGridLines)
    {
        CGFloat lineDash[2];
        lineDash[0] = 5.0f;
        lineDash[1] = 5.0f;
        CGContextSetLineDash(cgContext, 0.0f, lineDash, 2);
    }
	CGContextSetLineWidth(cgContext, 0.3f);
	UIColor *gridColor = xGridColor;
	
	// determine the grid spacing
	float gridSpaceX = xPad * ceil(minGridX / xPad);
	float gridSpaceY = yPad * ceil(minGridY / yPad);
	
	int xLines = ceil(chartFrame.size.width / gridSpaceX);
	int yLines = ceil(chartFrame.size.height / gridSpaceY);
    	
	// X-axis grid lines
	float xPos = chartFrame.origin.x;
	float yPos = chartFrame.origin.y + chartFrame.size.height;
	CGRect lastLabelRect = CGRectZero;	
	for (int x = 0; x < xLines; x++)
	{
		CGContextMoveToPoint(cgContext, xPos, yPos);
		CGContextAddLineToPoint(cgContext, xPos, yPos - chartFrame.size.height);
		CGContextSetStrokeColorWithColor(cgContext, gridColor.CGColor);
		
		// draw the label - if it will overlap, then don't draw it
        if (drawXLabels)
        {
            NSString *xLabelTxt = @"xLabel";
            CGSize labelSize = [xLabelTxt sizeWithFont:[UIFont fontWithName:@"Arial" size:10]];
            [gridColor set];
            
            float labelX = xPos - (labelSize.width / 2);
            
            CGRect cLabelRect = CGRectMake(labelX, (yPos + labelYPad), labelSize.width, labelSize.height);
            
            if (!CGRectIntersectsRect(lastLabelRect, cLabelRect))
            {
                [xLabelTxt drawInRect:cLabelRect
                             withFont:[UIFont fontWithName:@"Arial" size:10]];
                lastLabelRect = cLabelRect;
            }
        }
		
		xPos += gridSpaceX;
	}
    CGContextStrokePath(cgContext);

	// Y-Axis lines
    gridColor = yGridColor;
	xPos = chartFrame.origin.x;
	yPos = chartFrame.origin.y + chartFrame.size.height;
	for (int y = 0; y < yLines; y++)
	{
		CGContextMoveToPoint(cgContext, xPos, yPos);
		CGContextAddLineToPoint(cgContext, xPos + chartFrame.size.width, yPos);
		CGContextSetStrokeColorWithColor(cgContext, gridColor.CGColor);
		if (drawYLabels)
		{
			float yValue = ((float)y / (float)yLines) * (_chartRange.max - _chartRange.min);
			
			if (y == 0)
				yValue = _chartRange.min;
			//NSLog(@"yValue: %f", yValue);
			
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
			
			[labelString drawInRect:CGRectMake(0 + yLabelOffset, labelY, labelSize.width, labelSize.height)
						   withFont:[UIFont fontWithName:@"Arial" size:10]];
			
			// draw the top label
			if (y == (yLines - 1))
			{
				if (yFormatter != nil)
				{
					labelString = [yFormatter stringForObjectValue:[NSNumber numberWithFloat:_chartRange.max]];
				}
				else
				{
					labelString = [[NSNumber numberWithFloat:_chartRange.max] stringValue];
				}
				
				labelSize = [labelString sizeWithFont:[UIFont fontWithName:@"Arial" size:10]];
				labelY = (chartTitle != nil) ? chartFrame.origin.y - (labelSize.height / 2) : chartFrame.origin.y;
				[labelString drawInRect:CGRectMake(0 + yLabelOffset, labelY, labelSize.width, labelSize.height)
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

- (float) axisXForValue:(float)value
{
    return chartFrame.origin.x + (xPad * value);
}


- (float) axisYForValue:(float)value
{
    float baseline = chartFrame.origin.y + chartFrame.size.height;
    return baseline - (value - _chartRange.min) * yPad;
}

- (void) renderData
{	
	// baseline is the bottom line of the chart
	float baseline = chartFrame.origin.y + chartFrame.size.height;
	CGPoint currentPoint = CGPointMake(chartFrame.origin.x, baseline);
	
	CGContextRef cgContext = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(cgContext, 1.0f);
	
    NSMutableArray *fillPath;
	int totalLines = [self.dataProvider count];
	for (int i = 0; i < totalLines; i++)
	{
		GRLineSeries *cSeries = (GRLineSeries *)[self.dataProvider objectAtIndex:i];
        
        if ([cSeries.data count] <= 0)
            continue;
        
        if (cSeries.lineStyle == LINESTYLE_FILL)
        {
            fillPath = [[NSMutableArray alloc] init];
            
            UIColor *fillColor = (cSeries.fillColor != nil) ? cSeries.fillColor : cSeries.lineColor;
            CGContextSetFillColorWithColor(cgContext, fillColor.CGColor);            
        }
        
        // set the series line color
        CGContextBeginPath(cgContext);
        CGContextSetStrokeColorWithColor(cgContext, cSeries.lineColor.CGColor);
        
        CGPoint segmentStart = currentPoint;
        CGPoint segmentEnd = currentPoint;
        
        int totalPoints = [cSeries.data count];
		for (int k = 0; k < totalPoints; k++)
		{	
			NSObject *cObj = [cSeries.data objectAtIndex:k];
            
            BOOL drawSegment = NO;
            if (cObj != [NSNull null])
            {
                float pointValue;
                
                if (cSeries.yField != nil)
                {
                    pointValue = [[(NSDictionary *)cObj objectForKey:cSeries.yField] floatValue];
                }
                else
                {
                    pointValue = [(NSNumber *)cObj floatValue];
                }
                
                currentPoint.y = [self axisYForValue:pointValue];
                
                if (k == 0)
                    segmentStart.y = currentPoint.y;
                
                // draw a solid line
                CGContextSetLineDash(cgContext, 0, nil, 0);
                drawSegment = YES;
            }
            
            // what sort of line should we draw?
            if (k > 0)
            {
                if (cObj == [NSNull null] || [cSeries.data objectAtIndex:k - 1] == [NSNull null])
                {
                    // null value, so draw a dashed line to the next complete point
                    CGFloat dash[] = {5.0, 5.0};
                    CGContextSetLineDash(cgContext, 0, dash, 2);
                }
            }
            
            // advance the drawing point to the next column            
            if (k == 0)
            {
                currentPoint.x = chartFrame.origin.x;
            }
            else
            {
                currentPoint.x += xPad;
            }
            segmentEnd = currentPoint;
            
            if (drawSegment)
            {
                CGPoint points[] = {segmentStart, segmentEnd};
                CGContextStrokeLineSegments(cgContext, points, 2);
                segmentStart = segmentEnd;
                
                if (cSeries.lineStyle == LINESTYLE_FILL)
                    [fillPath addObject:[NSValue valueWithCGPoint:segmentEnd]];
            }
		}
        
        // done w/ the series, reset the xPoint
        currentPoint.x = chartFrame.origin.x;
        
        // do we need to fill the path?
        if (cSeries.lineStyle == LINESTYLE_FILL)
        {
            CGContextMoveToPoint(cgContext, chartFrame.origin.x, baseline);
            
            // now trace the line, and then fill it
            float lastXPoint = chartFrame.origin.x;
            for (int i = 0; i < [fillPath count]; i++)
            {
                NSValue *pVal = [fillPath objectAtIndex:i];
                CGPoint cPoint = [pVal CGPointValue];
                CGContextAddLineToPoint(cgContext, cPoint.x, cPoint.y);
                lastXPoint = cPoint.x;
            }
            
            CGContextAddLineToPoint(cgContext, lastXPoint, baseline);
            CGContextClosePath(cgContext);
            CGContextDrawPath(cgContext, kCGPathFill);
            
            // cleanup, cleanup...
            [fillPath release];            
        }
	}
	
	UIGraphicsEndImageContext();
}

- (void) renderGuides
{
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(cgContext, 1.0f);
	CGContextBeginPath(cgContext);
	
	int totalLines = [self.guideLines count];
	for (int i = 0; i < totalLines; i++)
	{
        GRGuideLine *cLine = (GRGuideLine *)[self.guideLines objectAtIndex:i];
        //NSLog(@"cLine: %f", cLine.value);
        if (cLine.needsRedraw == NO)
            continue;
        
        // set the series line color
        CGContextSetStrokeColorWithColor(cgContext, cLine.lineColor.CGColor);        
        CGContextSetLineDash(cgContext, 0, nil, 0);
        
        CGPoint lineStart = CGPointZero;
        CGPoint lineEnd = CGPointZero;
        
        if (cLine.orientation == GUIDELINE_VERTICAL)
        {
            float xPoint = [self axisXForValue:cLine.value];
            lineStart = CGPointMake(xPoint, chartFrame.origin.y);
            lineEnd = CGPointMake(xPoint, chartFrame.origin.y + chartFrame.size.height);
        }
        
        if (cLine.orientation == GUIDELINE_HORIZONTAL)
        {
            float yPoint = [self axisYForValue:cLine.value];
            lineStart = CGPointMake(chartFrame.origin.x, yPoint);
            lineEnd = CGPointMake(chartFrame.origin.x + chartFrame.size.width, yPoint);
        }
        
		CGPoint points[] = {lineStart, lineEnd};
        CGContextStrokeLineSegments(cgContext, points, 2);
	}
    UIGraphicsEndImageContext();
}

- (void) calcChartArea
{
	// if we're rendering labels, adjust the grid frame to make room for them
	NSString *labelString;
    if (yFormatter != nil)
    {
        labelString = [yFormatter stringForObjectValue:[NSNumber numberWithFloat:_chartRange.max]];
    }
    else
    {
        labelString = [[NSNumber numberWithFloat:_chartRange.max] stringValue];
    }
    
    CGSize labelSize = [labelString sizeWithFont:[UIFont fontWithName:@"Arial" size:10]];
    
    if (drawYLabels && yLabelOffset >= 0)
    {
        chartFrame.origin.x += (labelSize.width + labelXPad);
        chartFrame.size.width -= (labelSize.width + labelXPad);     
    }
    
    if (drawXLabels)
        chartFrame.size.height -= (labelSize.height + labelYPad);
    
	
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
	yPad = chartFrame.size.height / (_chartRange.max - _chartRange.min);
//    NSLog(@"pad: %f %f", xPad, yPad);
//    NSLog(@"frame: %f %f, %f %f", chartFrame.origin.x, chartFrame.origin.y, chartFrame.size.width, chartFrame.size.height);
}


// Returns the range of the chart, but also stores the value away into _chartRange
- (GRRange) getChartRange
{
	NSMutableArray *maxValues = [[NSMutableArray alloc] init];
	NSMutableArray *minValues = [[NSMutableArray alloc] init];
	
	int totalLines = [self.dataProvider count];
	for (int i = 0; i < totalLines; i++)
	{
		GRLineSeries *cSeries = (GRLineSeries *)[self.dataProvider objectAtIndex:i];
        
        // filter any null values out of the series before searching for the min/max
        NSMutableArray *tmpSeries = [NSMutableArray arrayWithArray:cSeries.data];
        [tmpSeries removeObjectIdenticalTo:[NSNull null]];
        
        if ([tmpSeries count] <= 0)
            continue;

		if (cSeries.yField != nil)
		{
			[maxValues addObject:[tmpSeries valueForKeyPath:[NSString stringWithFormat:@"@max.%@", cSeries.yField]]];
			[minValues addObject:[tmpSeries valueForKeyPath:[NSString stringWithFormat:@"@min.%@", cSeries.yField]]];
		}
		else
		{
			[maxValues addObject:[tmpSeries valueForKeyPath:@"@max.floatValue"]];
			[minValues addObject:[tmpSeries valueForKeyPath:@"@min.floatValue"]];
		}
	}
	
	GRRange range;
	range.min = [[minValues valueForKeyPath:@"@min.floatValue"] floatValue];
	range.max = [[maxValues valueForKeyPath:@"@max.floatValue"] floatValue];
	
	[minValues release];
	[maxValues release];
    
    // if the override range values aren't zero, then use those, provided that they're outside
    // the actual data range
    if (overrideRange.min != 0)
        range.min = MIN(overrideRange.min, range.min);
    
    if (overrideRange.max != 0)
        range.max = MAX(overrideRange.max, range.max);
    
    _chartRange = range;
	
//    NSLog(@"chart range: %f-%f", range.min, range.max);
	return range;
}

#pragma mark -
#pragma mark Cleanup
- (void)dealloc {
	
	[_dataProvider release];
    [guideLines release];
    [yFormatter release];
    [xFormatter release];
    [chartTitle release];
	
    [super dealloc];
}


@end
