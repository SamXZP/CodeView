//
//  ViewController.m
//  CodeView
//
//  Created by zksz on 2019/9/11.
//  Copyright © 2019 meb. All rights reserved.
//

#import "ViewController.h"
#import "CodeView/CodeView.h"
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CodeView *codeView = [[CodeView alloc]initWithFrame:CGRectMake(50, 160, SCREEN_WIDTH - 100, 50) codeNumber:6 style:CodeStyle_border labelFont:20 labelTextColor:UIColor.blackColor mainColor:UIColor.orangeColor normalColor:UIColor.grayColor selectCodeBlock:^(NSString * code) {
        NSLog(@"code === %@",code);
    }];
    [self.view addSubview:codeView];
}


@end
