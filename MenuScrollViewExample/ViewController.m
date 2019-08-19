//
//  ViewController.m
//  MenuScrollViewExample
//
//  Created by 雷琦玮 on 2019/8/19.
//  Copyright © 2019 雷琦玮. All rights reserved.
//

#import "ViewController.h"
#import "MenuScrollView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MenuScrollView *menuScrollView1;
@property (weak, nonatomic) IBOutlet MenuScrollView *menuScrollView2;
@property (weak, nonatomic) IBOutlet MenuScrollView *menuScrollView3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.menuScrollView1.menuTitles = @[@"1",@"12",@"123",@"1234"];
    
    //
    self.menuScrollView2.menuTitles = @[@"1",@"12",@"123",@"1234",@"12345"];
    
    //
    self.menuScrollView3.menuTitles = @[@"1",@"12",@"123",@"1234",@"12345",@"123456",@"1234567"];
}

@end
