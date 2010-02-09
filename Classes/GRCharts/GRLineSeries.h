//
//  GRLineSeries.h
//  GRCharts
//
//  Created by Joshua Buhler on 1/30/10.
//  Copyright 2010 Rain. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GRLineSeries : NSObject {
	NSArray		*data;
	UIColor		*lineColor;
	
	NSString	*xField;
	NSString	*yField;
}

@property	(nonatomic, retain) NSArray *data;
@property	(nonatomic, retain)	UIColor *lineColor;

@property	(nonatomic, retain) NSString *xField;
@property	(nonatomic, retain) NSString *yField;

- (id) initWithData:(NSArray *)lineData andColor:(UIColor *)color;

@end
