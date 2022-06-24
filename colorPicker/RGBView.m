//
//  RGBView.m
//  colorPicker
//
//  Created by 李博 on 2022/1/12.
//

#import "RGBView.h"

@implementation RGBView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize size = self.frame.size;
    CGPoint center =CGPointMake(floorf(size.width/2.0f),floorf(size.height/2.0f));
    CGFloat radius = floorf(size.width/2.0f);
    
    // 创建RGB色彩空间，创建这个以后，context里面用的颜色都是用RGB表示
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextClip(context);
    NSInteger numberOfSegments =360;
    
    for(CGFloat i =0; i < numberOfSegments; i++) {
        UIColor*color = [UIColor colorWithHue:i/(float)numberOfSegments saturation:1 brightness:1 alpha:1];

//            CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGFloat segmentAngle =2*M_PI/ (float)numberOfSegments;
        CGPoint start = center;
        CGPoint end =CGPointMake(center.x+ radius *cosf(i * segmentAngle), center.y+ radius *sinf(i * segmentAngle));
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,0, start.x, start.y);
        CGFloat offsetFromMid =2.f*(M_PI/180);
        CGPoint end1 =CGPointMake(center.x+ radius *cosf(i * segmentAngle-offsetFromMid), center.y+ radius *sinf(i * segmentAngle-offsetFromMid));
        CGPoint end2 =CGPointMake(center.x+ radius *cosf(i * segmentAngle+offsetFromMid), center.y+ radius *sinf(i * segmentAngle+offsetFromMid));
        CGPathAddLineToPoint(path,0, end1.x, end1.y);
        CGPathAddLineToPoint(path,0, end2.x, end2.y);
        CGContextSaveGState(context);
        CGContextAddPath(context, path);
        CGPathRelease(path);
        CGContextClip(context);
        
        NSArray*colors =@[(__bridge id)color.CGColor, (__bridge id)color.CGColor];
        CGGradientRef gradient =CGGradientCreateWithColors(rgbColorSpace, (__bridge CFArrayRef)colors,NULL);
        CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
        CGContextRestoreGState(context);
    }
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRestoreGState(context);
    CGContextSetStrokeColorWithColor(context, UIColor.clearColor.CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextStrokeEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
}

@end
