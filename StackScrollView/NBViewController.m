//
//  NBViewController.m
//  StackScrollView
//
//  Created by Nanda Ballabh on 11/07/14.
//  Copyright (c) 2014 Nanda. All rights reserved.
//

#import "NBViewController.h"

@interface NBViewController ()

@end

@implementation NBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect rect = {{20,40},{260,340}};
    NBStackScrollImageView *stackView = [[NBStackScrollImageView alloc]initWithFrame:rect ZMarginValue:5 XMarginValue:10 AngleValue:0.0 Alpha:1000];
    stackView.stackPostion = StackPositionRight;
    stackView.borderColor = [UIColor whiteColor];
    stackView.delegate = self;
    for (int index = 0; index < 6; index++) {
        [stackView addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",index]]];
    }
    [self.view addSubview:stackView];
    [stackView setImageShadowsWtihDirectionX:2 Y:2 Alpha:0.7];
    [stackView reLoadUIview];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
