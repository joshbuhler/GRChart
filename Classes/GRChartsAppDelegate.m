//
//  GRChartsAppDelegate.m
//  GRCharts
//
//  Created by Joshua Buhler on 1/23/10.
//  Copyright Rain 2010. All rights reserved.
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
