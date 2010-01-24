//
//  GRLineChart.h
//  MW2Stats
//
//  Created by Joshua Buhler on 1/23/10.
//  Copyright 2010 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRDataProvider.h"

@interface GRLineChart : UIView {
	//id<GRDataProvider>	_dataProvider;
	NSArray		*_dataProvider;
	BOOL		_dataProviderDirty;
	
	BOOL	redrawChart;
	
}

struct GRRange {
	float min;
	float max;
};
typedef struct GRRange GRRange;

@property (nonatomic, retain) NSArray *dataProvider;


@end
