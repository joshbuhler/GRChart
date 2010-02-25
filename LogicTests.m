//
//  Logictests.m
//  GRCharts
//
//  Created by Joshua Buhler on 1/24/10.
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

#import "LogicTests.h"


@implementation LogicTests

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle


- (void) testMinRange
{
	GRLineChart *testChart = [[GRLineChart alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
	GRRange testRange;
	
	// build the test data
	NSMutableArray *test1 = [[NSMutableArray alloc] init];
	int minVal = 0;
	for (int i = minVal; i < 10; i++)
	{
		[test1 addObject:[NSNumber numberWithFloat:(float)i]];
	}
	testChart.dataProvider = test1;
	testRange = [testChart getChartRange];
	[test1 release];
	
	STAssertTrue(testRange.min == minVal, @"Min range failure");
	
	NSMutableArray *test2 = [[NSMutableArray alloc] init];
	minVal = 5;
	for (int i = minVal; i < 10; i++)
	{
		[test2 addObject:[NSNumber numberWithFloat:(float)i]];
	}
	testChart.dataProvider = test2;
	testRange = [testChart getChartRange];
	[test2 release];
	
	STAssertTrue(testRange.min == minVal, @"Min range failure");
	
	NSMutableArray *test3 = [[NSMutableArray alloc] init];
	minVal = -4;
	for (int i = minVal; i < 10; i++)
	{
		[test3 addObject:[NSNumber numberWithFloat:(float)i]];
	}
	testChart.dataProvider = test3;
	testRange = [testChart getChartRange];
	[test3 release];
	
	STAssertTrue(testRange.min == minVal, @"Min range failure");
	
	NSMutableArray *test4 = [[NSMutableArray alloc] init];
	for (int i = 5; i <= 10; i++)
	{
		[test4 addObject:[NSNumber numberWithFloat:(float)i]];
	}
	testChart.dataProvider = test4;
	testRange = [testChart getChartRange];
	[test4 release];
	
	STAssertTrue(testRange.max == 10, @"Max range failure");	
}


#endif


@end
