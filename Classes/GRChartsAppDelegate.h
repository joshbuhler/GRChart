//
//  GRChartsAppDelegate.h
//  GRCharts
//
//  Created by Joshua Buhler on 1/23/10.
//  Copyright Rain 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRLineChart.h"

@interface GRChartsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	GRLineChart	*lineChart;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

