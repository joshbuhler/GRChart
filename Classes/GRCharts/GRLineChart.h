//
//  GRLineChart.h
//  GRCharts
//
//  Created by Joshua Buhler on 1/23/10.
//  Copyright (c) 2010 Josh Buhler - joshbuhler.com
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

#import <UIKit/UIKit.h>
#import "GRLineSeries.h"
#import "GRGuideLine.h"

struct GRRange {
	float min;
	float max;
};
typedef struct GRRange GRRange;

static inline GRRange GRRangeMake(CGFloat min, CGFloat max)
{
    GRRange r;
    r.min = min;
    r.max = max;
    return r;
}

@interface GRLineChart : UIView {
	CGRect		chartFrame;
	
	float		minGridX;
	float		minGridY;
	
	float		xPad;
	float		yPad;
	
	float		labelXPad;
	float		labelYPad;
    
    BOOL        drawXLabels;
    BOOL        drawYLabels;
	
	NSFormatter	*yFormatter;
	NSFormatter *xFormatter;
	
	NSString	*chartTitle;
    
    NSMutableArray  *guideLines;
    
    GRRange     overrideRange;
    
    UIColor     *bgColor;
    UIColor     *xGridColor;
    UIColor     *yGridColor;
    
    BOOL        dashedGridLines;
    
    float       yLabelOffset;
    
    UIFont      *labelFont;
    
@private
    GRRange _chartRange;
    BOOL	redrawChart;
    
    BOOL    _guidelinesDirty;
    BOOL    redrawGuides;
    
    NSArray	*_dataProvider;
	BOOL	_dataProviderDirty;
    
    int     _xLabelPos;
}

#define x_LABEL_POS_BOTTOM  0
#define x_LABEL_POS_TOP     1

@property (nonatomic, retain) NSArray *dataProvider;

@property (nonatomic) float minGridX;
@property (nonatomic) float minGridY;

@property (nonatomic) BOOL drawXLabels;
@property (nonatomic) BOOL drawYLabels;
@property (nonatomic) int xLabelPos;

@property (nonatomic, retain) UIFont *labelFont;

@property (nonatomic) float yLabelOffset;

@property (nonatomic) BOOL dashedGridLines;

@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, retain) UIColor *xGridColor;
@property (nonatomic, retain) UIColor *yGridColor;

@property (nonatomic) GRRange overrideRange;

@property (nonatomic, retain) NSFormatter *yFormatter;
@property (nonatomic, retain) NSFormatter *xFormatter;

@property (nonatomic, retain) NSString *chartTitle;

@property (nonatomic, retain) NSMutableArray *guideLines;

- (GRRange) getChartRange;

@end
