//
//  ColorPicker.h
//  colorPicker
//
//  Created by 李博 on 2022/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorPicker : UIView

@property (nonatomic, copy) void(^currentColorBlock)(UIColor *color);

@end

NS_ASSUME_NONNULL_END
