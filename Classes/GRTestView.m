//
//  GRTestView.m
//  GRCharts
//
//  Created by Joshua Buhler on 1/24/10.
//  Copyright (c) 2010 Josh Buhler - joshbuhler.com
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

#import "GRTestView.h"

@implementation GRTestView


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	lineChart = [[GRLineChart alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
	[self.view addSubview:lineChart];
	
	int numPoints = 15;
	int cPoint = -3;
	NSMutableArray *test1 = [[NSMutableArray alloc] init];
	for (int i = 0; cPoint <= 15; i++)
	{
//		[test1 addObject:[NSNumber numberWithFloat:(float)(arc4random() % 15) / (float)((arc4random() % 15) + 1)]];
        [test1 addObject:[NSNumber numberWithInt:cPoint]];
        cPoint++;
		//NSLog(@"test1 num: %f", [[test1 objectAtIndex:i] floatValue]);
	}
    
    // insert a missing value or two, just for testing that
    [test1 replaceObjectAtIndex:3 withObject:[NSNull null]];
    [test1 replaceObjectAtIndex:6 withObject:[NSNull null]];
    [test1 replaceObjectAtIndex:7 withObject:[NSNull null]];
	
	GRLineSeries *series1 = [[GRLineSeries alloc] initWithData:test1 andColor:[UIColor orangeColor]];
	
    
	NSMutableArray *test2 = [[NSMutableArray alloc] init];
	for (int i = 0; [test2 count] < numPoints; i++)
	{
		NSMutableDictionary *newObj = [[NSMutableDictionary alloc] init];
		float rndValue = (float)(arc4random() % 10) / (float)((arc4random() % 10) + 1);
		[newObj setObject:[NSNumber numberWithFloat:rndValue]
				   forKey:@"price"];
		[newObj setObject:[NSNumber numberWithInt:i]
										   forKey:@"day"];
        [newObj setObject:[NSString stringWithFormat:@"Item %d", i]
                   forKey:@"stringX"];
		[test2 addObject:newObj];
		//NSLog(@"test2 num: %f", rndValue);
		[newObj release];
	}
    [test2 replaceObjectAtIndex:9 withObject:[NSNull null]];
	
	GRLineSeries *series2 = [[GRLineSeries alloc] initWithData:test2 andColor:[UIColor cyanColor]];
	series2.xField = @"stringX";
	series2.yField = @"price";
	series2.xLabel = @"Date";
	series2.yLabel = @"Price";
    series2.lineStyle = LINESTYLE_FILL;
    series2.fillColor = [UIColor lightGrayColor];
    
	//lineChart.chartTitle = @"Item Price / Time";
    lineChart.drawXLabels = YES;
    lineChart.drawYLabels = YES;
	
	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:0];
	[numberFormatter setMaximumFractionDigits:2];
    lineChart.xFormatter = numberFormatter;
	lineChart.yFormatter = numberFormatter;
	
	lineChart.dataProvider = [NSArray arrayWithObjects:series2, series1, nil];
	
	[test1 release];
	[test2 release];
	[series1 release];
	[series2 release];
    
    lineChart.overrideRange = GRRangeMake(-3, 10);
    
    lineChart.xGridColor = [UIColor redColor];
    lineChart.yGridColor = [UIColor orangeColor];
    
    // guidelines
    redLine = [[[GRGuideLine alloc] init] retain];
    redLine.value = 0;
    redLine.lineColor = [UIColor redColor];
    
    GRGuideLine *blueLine = [[GRGuideLine alloc] init];
    blueLine.value = 7.5;
    blueLine.lineColor = [UIColor blueColor];
    
    GRGuideLine *greenLine = [[GRGuideLine alloc] init];
    greenLine.value = 3;
    greenLine.lineColor = [UIColor greenColor];
    greenLine.orientation = GUIDELINE_HORIZONTAL;
    
    NSMutableArray *guides = [[NSMutableArray alloc] init];
    [guides addObject:redLine];
    [guides addObject:blueLine];
    [guides addObject:greenLine];
    
    lineChart.guideLines = guides;
    
    [blueLine release];
    [greenLine release];
    [guides release];
    
    // test animating a guide line
    /*
    [NSTimer scheduledTimerWithTimeInterval:.05f
                                     target:self selector:@selector(onTimer:)
                                   userInfo:nil repeats:YES];
     */
}

- (void) onTimer:(NSTimer *)timer
{
    redLine.value += .1;
    [lineChart setNeedsDisplay];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    [redLine release];
    
    [super dealloc];
}


@end
