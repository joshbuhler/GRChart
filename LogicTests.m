//
//  Logictests.m
//  GRCharts
//
//  Created by Joshua Buhler on 1/24/10.
//  Copyright 2010 Rain. All rights reserved.
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
