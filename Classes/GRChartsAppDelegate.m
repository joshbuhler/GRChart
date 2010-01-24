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
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
