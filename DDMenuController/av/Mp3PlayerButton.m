//
//  Mp3PlayerButton.m
//  NCMusicEngine Example
//
//  Created by Aster0id on 13-5-5.
//  Copyright (c) 2013年 NC. All rights reserved.
//
#define SIDE_WEITH 4
#define _R 1.0
#define _G 0.0
#define _B 0.0
#define _A 1.0
#define PLAY_IMAGE_STR @"按钮-播放.png"
#define PAUSE_IMAGE_STR @"按钮-暂停.png"


#import "Mp3PlayerButton.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>

@implementation Mp3PlayerButton

@synthesize mp3URL=_mp3URL;
@synthesize playImage,pauseImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _progress = 0.0;
        _r = _R;
		_g = _G;
		_b = _B;
		_a = _A;
        playImage = [UIImage imageNamed:PLAY_IMAGE_STR];
        pauseImage = [UIImage imageNamed:PAUSE_IMAGE_STR];
        [self setBackgroundImage:playImage forState:UIControlStateNormal];
    }
    return self;
}

-(void) setProgress:(CGFloat) newProgress
{
	_progress = newProgress;
    
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
////    [image drawInRect:rect];
    
    // find the radius and position for the largest circle that fits in the UIView's frame.
    int radius, x, y;
    int offset = SIDE_WEITH;
    
    // in case the given frame is not square (oblong) we need to check and use the shortest side as our radius.
    CGRect frame = self.frame;
    if (frame.size.width > frame.size.height) {
        radius = frame.size.height;
        // we want our circle to be in the center of the frame.
        int delta = frame.size.width - radius;
        x = delta/2;
        y = 0;
    } else {
        radius = frame.size.width;
        int delta = frame.size.height - radius;
        y = delta/2;
        x = 0;
    }
    
    // store the largest circle's position and radius in class variable.
    _outerCircleRect = CGRectMake(x, y, radius, radius);
    // store the inner circles rect, this inner circle will have a radius 10pixels smaller than the outer circle.
    // we want to the inner circle to be in the middle of the outer circle.
    _innerCircleRect = CGRectMake(x+offset, y+offset, radius-2*offset , radius-2*offset);
    
    
    // get the drawing canvas (CGContext):
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // save the context's previous state:
    CGContextSaveGState(context);
    
    // our custom drawing code will go here:
    
    // Draw the gray background for our progress view:
    
    // gradient properties:
    CGGradientRef myGradient;
    // You need tell Quartz your colour space (how you define colours), there are many colour spaces: RGBA, black&white...
    CGColorSpaceRef myColorspace;
    // the number of different colours
    size_t num_locations = 3;
    // the location of each colour change, these are between 0 and 1, zero is the first circle and 1 is the end circle, so 0.5 is in the middle.
    CGFloat locations[3] = { 0.0, 0.5 ,1.0 };
    // this is the colour components array, because we are using an RGBA system each colour has four components (four numbers associated with it).
    CGFloat components[12] = {
        0.4, 0.4, 0.4, 0.9,    // Start colour
        0.9, 0.9, 0.9, 1.0,	// middle colour
        0.4, 0.4, 0.4, 0.9
    }; // End colour
    
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components,locations, num_locations);
    
    // gradient start and end points
    CGPoint myStartPoint, myEndPoint;
    CGFloat myStartRadius, myEndRadius;
    myStartPoint.x = _innerCircleRect.origin.x + _innerCircleRect.size.width/2;
    myStartPoint.y = _innerCircleRect.origin.y + _innerCircleRect.size.width/2;
    myEndPoint.x = _innerCircleRect.origin.x + _innerCircleRect.size.width/2;
    myEndPoint.y = _innerCircleRect.origin.y + _innerCircleRect.size.width/2;
    myStartRadius = _innerCircleRect.size.width/2 ;
    myEndRadius = _outerCircleRect.size.width/2;
    
    // draw the gradient.
    /*CGContextDrawRadialGradient(context,
     myGradient,
     myStartPoint, myStartRadius, myEndPoint, myEndRadius, 0);
	 CGGradientRelease(myGradient);*/
    
    // draw outline so that the edges are smooth:
	
    // set line width
    //CGContextSetLineWidth(context, 1);
    // set the colour when drawing lines R,G,B,A. (we will set it to the same colour we used as the start and end point of our gradient )
    /*CGContextSetRGBStrokeColor(context, 0.4,0.4,0.4,0.9);
	 
	 // draw an ellipse in the provided rectangle
	 CGContextAddEllipseInRect(context, _outerCircleRect);
	 CGContextStrokePath(context);*/
    
    /*CGContextAddEllipseInRect(context, _innerCircleRect);
	 CGContextStrokePath(context);*/
    
    
    // Draw the progress:
    
    // First clip the drawing area:
    // save the context before clipping
    CGContextSaveGState(context);
    CGContextMoveToPoint(context,
                         _outerCircleRect.origin.x + _outerCircleRect.size.width/2, // move to the top center of the outer circle
                         _outerCircleRect.origin.y +1); // the Y is one more because we want to draw inside the bigger circles.
    // add an arc relative to _progress
    CGContextAddArc(context,
                    _outerCircleRect.origin.x + _outerCircleRect.size.width/2,
                    _outerCircleRect.origin.y + _outerCircleRect.size.width/2,
                    _outerCircleRect.size.width/2-1,
                    -M_PI/2,
                    (-M_PI/2 + _progress*2*M_PI), 0);
    CGContextAddArc(context,
                    _outerCircleRect.origin.x + _outerCircleRect.size.width/2,
                    _outerCircleRect.origin.y + _outerCircleRect.size.width/2,
                    _outerCircleRect.size.width/2 - 9,
                    (-M_PI/2 + _progress*2*M_PI),
                    -M_PI/2, 1);
    // use clode path to connect the last point in the path with the first point (to create a closed path)
    CGContextClosePath(context);
    // clip to the path stored in context
    CGContextClip(context);
    
    // Progress drawing code comes here:
    
    // set the gradient colours based on class variables.
    CGFloat components2[12] = {  _r, _g, _b, _a, // Start color
        ((_r + 0.5 > 1) ? 1 : (_r+0.5) ) , ((_g + 0.5 > 1) ? 1 : (_g+0.5) ), ((_b + 0.5 > 1) ? 1 : (_b+0.5) ), ((_a + 0.5 > 1) ? 1 : (_a+0.5)),
        _r, _g, _b, _a }; // End color
    
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components2,locations, num_locations);
    
    myStartPoint.x = _innerCircleRect.origin.x + _innerCircleRect.size.width/2;
    myStartPoint.y = _innerCircleRect.origin.y + _innerCircleRect.size.width/2;
    myEndPoint.x = _innerCircleRect.origin.x + _innerCircleRect.size.width/2;
    myEndPoint.y = _innerCircleRect.origin.y + _innerCircleRect.size.width/2;
    // set the radias for start and endpoints a bit smaller, because we want to draw inside the outer circles.
    myStartRadius = _innerCircleRect.size.width/2;
    myEndRadius = _outerCircleRect.size.width/2;
    
    CGContextDrawRadialGradient(context,
                                myGradient,
                                myStartPoint, myStartRadius, myEndPoint, myEndRadius, 0);
	
    // release myGradient and myColorSpace
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorspace);
    
    
    // draw circle on the outline to smooth it out.
    
    CGContextSetRGBStrokeColor(context, _r,_g,_b,_a);
    
    // draw an ellipse in the provided rectangle
    CGContextAddEllipseInRect(context, _outerCircleRect);
    CGContextStrokePath(context);
    
    CGContextAddEllipseInRect(context, _innerCircleRect);
    CGContextStrokePath(context);
    
    
    //restore the context and remove the clipping area.
    CGContextRestoreGState(context);
    
    // restore the context's state when we are done with it:
    CGContextRestoreGState(context);
    
    
    /*CGPathRef circlePath = CGPathCreateMutable();
     CGPathAddEllipseInRect(circlePath , NULL , rect);
     CAShapeLayer *circle = [[CAShapeLayer alloc] init];
     circle.path = circlePath;
     circle.opacity = 0.5;
     [self.imageView.layer addSublayer:circle];
     CGPathRelease( circlePath );
     [circle release];*/
}
@end
