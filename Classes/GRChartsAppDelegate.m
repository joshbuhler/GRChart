//
//  GRChartsAppDelegate.m
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

#import "GRChartsAppDelegate.h"

@implementation GRChartsAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
	
	lineChart = [[GRLineChart alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
	[window addSubview:lineChart];
	
	NSMutableArray *test1 = [[NSMutableArray alloc] init];
	for (int i = 0; [test1 count] < 10; i++)
	{
		[test1 addObject:[NSNumber numberWithFloat:(float)(arc4random() % 10) / (float)((arc4random() % 10) + 1)]];
		NSLog(@"num: %f", [[test1 objectAtIndex:i] floatValue]);
	}
	
	lineChart.dataProvider = test1;
	[test1 release];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
