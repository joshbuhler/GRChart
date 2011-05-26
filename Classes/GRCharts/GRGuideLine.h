//
//  GRGuideLine.h
//  GRCharts
//
//  Created by Joshua Buhler on 5/26/11.
//  Copyright 2011 Rain. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GRGuideLine : NSObject {
    UIColor *lineColor;
    float   value;
    int     orientation;
        
    BOOL    needsRedraw;
}

#define GUIDELINE_HORIZONTAL    0
#define GUIDELINE_VERTICAL      1

@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic) float value;
@property (nonatomic) int orientation;
@property (nonatomic) BOOL needsRedraw;

@end
