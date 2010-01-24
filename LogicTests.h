//
//  Logictests.h
//  GRCharts
//
//  Created by Joshua Buhler on 1/24/10.
//  Copyright 2010 Rain. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

//#import "application_headers" as required
#import "GRLineChart.h"


@interface LogicTests : SenTestCase {

}

#if USE_APPLICATION_UNIT_TEST
- (void) testAppDelegate;       // simple test on application
#else
- (void) testMinRange;              // simple standalone test
#endif

@end
