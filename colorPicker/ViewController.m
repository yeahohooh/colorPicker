//
//  ViewController.m
//  colorPicker
//
//  Created by 李博 on 2022/1/12.
//

#import "ViewController.h"
#import "ColorPicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ColorPicker *view = [[ColorPicker alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, self.view.frame.size.width-40, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"当前颜色";
    [self.view addSubview:label];
    
    UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-75, 100, 150, 150)];
    [self.view addSubview:testView];
    view.currentColorBlock = ^(UIColor *color){
        label.textColor = color;
        testView.backgroundColor = color;
    };
}


@end
