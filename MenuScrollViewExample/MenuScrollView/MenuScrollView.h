//
//  MenuScrollView.h
//  INYue
//
//  Created by 雷琦玮 on 16/6/5.
//  Copyright © 2016年 上海科匠信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuScrollView : UIScrollView

@property (nonatomic, strong) NSArray *menuTitles;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIFont *titleNormalFont;
@property (nonatomic, strong) UIFont *titleSelectFont;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) NSMutableArray<UIButton *> *titleButtons;

@property (nonatomic, copy) void(^selectedMenu)(UIButton *button);

/**
 *  点击事件
 *
 *  @param sender      点击button
 */
- (void)clickOnTitleButton:(UIButton *)sender;

/**
 *  设置选中按钮
 *
 *  @param sender      选中button
 */
- (void)selectButton:(UIButton *)sender;

@end
