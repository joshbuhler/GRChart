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
	
	lineChart = [[GRLineChart alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
	[window addSubview:lineChart];
	
	NSMutableArray *test1 = [[NSMutableArray alloc] init];
	for (int i = 0; i < 10; i++)
	{
		[test1 addObject:[NSNumber numberWithFloat:(float)i]];
		NSLog(@"i %f", (float)i);
	}
	
	lineChart.dataProvider = test1;
	[test1 release];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
