//
//  ColorPicker.m
//  colorPicker
//
//  Created by 李博 on 2022/1/12.
//

#import "ColorPicker.h"

@interface ColorPicker()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation ColorPicker

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        UIGraphicsBeginImageContext(self.bounds.size);
        [self drawGradientCircle];
        
        //从Context中获取图像，并显示在界面上
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.imageView.image = img;
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    
    if (pow(pointL.x - self.bounds.size.width/2, 2)+pow(pointL.y-self.bounds.size.width/2, 2) <= pow(self.bounds.size.width/2, 2)) {
        
        UIColor *color = [self colorAtPixel:pointL];
        UIColor *color2 = [self colorWithPoint:pointL];
        if (self.currentColorBlock) {
            
            self.currentColorBlock(color2);
        }
    }
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    
    if (pow(pointL.x - self.bounds.size.width/2, 2)+pow(pointL.y-self.bounds.size.width/2, 2) <= pow(self.bounds.size.width/2, 2)) {
        
        UIColor *color = [self colorAtPixel:pointL];
        UIColor *color2 = [self colorWithPoint:pointL];
        if (self.currentColorBlock) {
            
            self.currentColorBlock(color2);
        }
    }
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    
    if (pow(pointL.x - self.bounds.size.width/2, 2)+pow(pointL.y-self.bounds.size.width/2, 2) <= pow(self.bounds.size.width/2, 2)) {
        
        UIColor *color = [self colorAtPixel:pointL];
        UIColor *color2 = [self colorWithPoint:pointL];
        if (self.currentColorBlock) {
            
            self.currentColorBlock(color2);
        }
    }
}

- (UIColor *)colorWithPoint:(CGPoint)point {
    CGPoint center = CGPointMake(floorf(self.bounds.size.width/2.0f), floorf(self.bounds.size.height/2.0f));
    CGFloat radius = floorf(self.bounds.size.width/2.0f);
    CGFloat dx = point.x - center.x;
    CGFloat dy = point.y - center.y;
    CGFloat touchRadius = sqrtf(powf(dx, 2)+powf(dy, 2));
    
    CGFloat saturation = 0;
    CGFloat hue = 0;
    
//    if (touchRadius > radius) {
//        saturation = 1.f;
//    } else {
//        saturation = touchRadius / radius;
//    }

    CGFloat angleRad = atan2f(dy, dx);
    CGFloat angleDeg = angleRad * (180.0f/M_PI);
    
    if (angleDeg < 0.f) {
       angleDeg += 360.f;
    }
    hue = angleDeg / 360.0f;
    UIColor *color = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
    return color;
}



//获取图片某一点的颜色
- (UIColor *)colorAtPixel:(CGPoint)point {
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.imageView.image.size.width, self.imageView.image.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.imageView.image.CGImage;
    NSUInteger width = self.imageView.image.size.width;
    NSUInteger height = self.imageView.image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    NSLog(@"%f***%f***%f***%f",red,green,blue,alpha);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)drawGradientCircle {
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
//    CGContextSetStrokeColorWithColor(context, UIColor.clearColor.CGColor);
//    CGContextSetLineWidth(context, 1);
//    CGContextStrokeEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
}

@end
