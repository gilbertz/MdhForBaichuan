//
//  CustomPageControl.m
//  demo
//
//  Created by huamulou on 14-9-6.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "CustomPageControl.h"
#import "Constants.h"


@implementation CustomPageControl

@synthesize dotCurrentColor;
@synthesize dotOtherColor;
@synthesize currentPage;
@synthesize numberOfPages;
@synthesize delegate;


- (void)setCurrentPage:(NSInteger)page {
    currentPage = MIN(MAX(0, page), self.numberOfPages - 1);
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)pages {
    numberOfPages = MAX(0, pages);
    currentPage = MIN(MAX(0, self.currentPage), numberOfPages - 1);
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Default colors.
        self.backgroundColor = [UIColor clearColor];
        self.dotCurrentColor = [UIColor blackColor];
        self.dotOtherColor = [UIColor lightGrayColor];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,100)];
//        label.textColor = [UIColor whiteColor];
//        label.text  =@"asdasdasd";
//        [self addSubview:label];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.dotCurrentColor = [UIColor blackColor];
        self.dotOtherColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRef borderContext = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetAllowsAntialiasing(borderContext, true);

    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages * MAIN_VIEW_BANNER_DOT_DIAMETER + MAX(0, self.numberOfPages - 1) * MAIN_VIEW_BANNER_DOT_SPACER;
    CGFloat x = CGRectGetMidX(currentBounds) - dotsWidth / 2;
    CGFloat y = CGRectGetMidY(currentBounds) - MAIN_VIEW_BANNER_DOT_WIDTH/2;
    for (int i = 0; i < self.numberOfPages; i++) {
        CGRect circleRect = CGRectMake(x, y, MAIN_VIEW_BANNER_DOT_DIAMETER, MAIN_VIEW_BANNER_DOT_DIAMETER);
        CGRect circleBorderRect = CGRectMake(x, y, MAIN_VIEW_BANNER_DOT_WIDTH, MAIN_VIEW_BANNER_DOT_WIDTH);
        if (i == self.currentPage) {
            CGContextSetFillColorWithColor(context, self.dotCurrentColor.CGColor);
            CGContextSetAlpha(context, self.dotCurrentAlpha);
        }
        else {
            CGContextSetFillColorWithColor(context, self.dotOtherColor.CGColor);
            CGContextSetAlpha(context, self.dotOtherAlpha);
        }
        CGContextFillEllipseInRect(context, circleRect);


        if (i == self.currentPage) {
            CGContextSetStrokeColorWithColor(borderContext, self.dotCurrentBorderColor.CGColor);
            CGContextSetAlpha(borderContext, self.dotCurrentBorderAlpha);
        }
        else {
            CGContextSetStrokeColorWithColor(borderContext, self.dotOtherBorderColor.CGColor);
            CGContextSetAlpha(borderContext, self.dotOtherBorderAlpha);

        }
        CGContextSetLineWidth(borderContext, VIEW_BORDERWIDTH);
        CGContextStrokeEllipseInRect(borderContext, circleBorderRect);



        x += MAIN_VIEW_BANNER_DOT_DIAMETER + MAIN_VIEW_BANNER_DOT_SPACER;


//        CGContextSetRGBStrokeColor(context, 1, 1.0, 1.0, 1.0);
//        CGContextSetLineWidth(context, 2.0);
//        CGContextAddRect(context, CGRectMake(2, 2, 270, 270));
//        CGContextStrokePath(context);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];

    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x - CGRectGetMidX(currentBounds);

    if (x < 0 && self.currentPage >= 0) {
        self.currentPage--;
        [self.delegate pageControlPageDidChange:self];
    }
    else if (x > 0 && self.currentPage < self.numberOfPages - 1) {
        self.currentPage++;
        [self.delegate pageControlPageDidChange:self];
    }

}

@end
