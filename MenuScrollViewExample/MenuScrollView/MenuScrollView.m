//
//  MenuScrollView.m
//  INYue
//
//  Created by 雷琦玮 on 16/6/5.
//  Copyright © 2016年 上海科匠信息科技有限公司. All rights reserved.
//

#define kRGB(r, g, b) [UIColor colorWithRed:((r) / 255.0)green:((g) / 255.0)blue:((b) / 255.0)alpha:1.0]
#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define kDefaultPlace 20

#import "MenuScrollView.h"
#import "Masonry.h"
#import "YYKit.h"

@interface MenuScrollView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, assign) float spaceOffset;

@end

@implementation MenuScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _spaceOffset = 0;
    
//    self.bounces = NO;
    self.clipsToBounds = YES;
    
    self.titleButtons = [NSMutableArray array];
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.titleNormalFont = [UIFont boldSystemFontOfSize:14];
    self.titleSelectFont = [UIFont boldSystemFontOfSize:18];
    self.backgroundColor = [UIColor whiteColor];
    self.titleNormalColor = kRGB(136, 136, 136);
    self.titleSelectedColor = [UIColor blackColor];
    self.lineColor = kRGB(0, 181, 236);
    self.lineHeight = 2.f;
    self.titleHeight = self.height - self.lineHeight;
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = self.lineColor;
    [self addSubview:self.lineView];
}

- (void)setMenuTitles:(NSArray *)menuTitles
{
    _menuTitles = menuTitles;
    
    if (self.titleButtons.count > 0 ) {
        for (UIButton *btn in self.titleButtons) {
            [btn removeFromSuperview];
        }
        [self.titleButtons removeAllObjects];
    }
    
    float contentWidth = 0;
    NSMutableArray *widths = @[].mutableCopy;
    for (NSString *title in _menuTitles) {
        float width = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSMutableDictionary dictionaryWithObject:self.titleSelectFont forKey:NSFontAttributeName] context:nil].size.width + 20;
        [widths addObject:[NSNumber numberWithFloat:width]];
        contentWidth += width;
    }
    
    if (contentWidth <= KScreenWidth) {
        _spaceOffset = (KScreenWidth - contentWidth) / _menuTitles.count;
        for (NSInteger i = 0; i < widths.count; i ++) {
            [widths replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:[widths[i] floatValue] + _spaceOffset]];
        }
        contentWidth = KScreenWidth;
    }
    
    self.contentSize = CGSizeMake(contentWidth, 0);
    
    for (NSUInteger i = 0; i < _menuTitles.count; i ++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleButtons addObject:titleBtn];
        titleBtn.backgroundColor = self.backgroundColor;
        [titleBtn setTitle:_menuTitles[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        titleBtn.titleLabel.font = self.titleNormalFont;
        titleBtn.tag = i;
        if (i == 0) {
            titleBtn.selected = YES;
            titleBtn.titleLabel.font = self.titleSelectFont;
            _selectedBtn = titleBtn;
        }
        [titleBtn addTarget:self action:@selector(clickOnTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.titleHeight);
            make.width.mas_equalTo(self.lineWidth != 0 ? self.lineWidth : [widths[i] floatValue]);
            make.top.equalTo(self);
            make.left.equalTo(i == 0 ? self : self.titleButtons[i - 1].mas_right);
        }];
        
    }
    
    [self.lineView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.lineHeight);
        make.width.mas_equalTo([widths[0] floatValue] - kDefaultPlace - self.spaceOffset);
        make.top.equalTo(self).offset(self.height - self.lineHeight);
        make.centerX.equalTo(self.titleButtons.firstObject);
    }];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(lineWidth);
    }];
}

- (void)clickOnTitleButton:(UIButton *)sender
{
    if (sender != _selectedBtn)
    {
        _selectedBtn.titleLabel.font = self.titleNormalFont;
        _selectedBtn.selected = NO;
        _selectedBtn = sender;
    }
    _selectedBtn.selected = YES;
    _selectedBtn.titleLabel.font = self.titleSelectFont;
    
    @weakify(self);
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self);
        
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.lineHeight);
            make.top.equalTo(self).offset(self.height - self.lineHeight);
            make.centerX.equalTo(sender);
            make.width.mas_equalTo(self.lineWidth != 0 ? self.lineWidth : sender.width - kDefaultPlace - self.spaceOffset);
        }];
        [self layoutIfNeeded];
        
        if (sender.centerX >= KScreenWidth / 2 && sender.centerX <= self.contentSize.width - KScreenWidth / 2) {
            self.contentOffset = CGPointMake(sender.centerX - KScreenWidth / 2, 0);
        }else if (sender.centerX <  KScreenWidth / 2) {
            self.contentOffset = CGPointMake(0, 0);
        }else if (sender.centerX > self.contentSize.width - KScreenWidth / 2) {
            self.contentOffset = CGPointMake(self.contentSize.width - KScreenWidth, 0);
        }
    }];
    if (self.selectedMenu) {
        self.selectedMenu(sender);
    }
}

- (void)selectButton:(UIButton *)sender
{
    for (UIButton *button in self.titleButtons) {
        if (button == sender) {
            button.selected = YES;
            self.selectedBtn = button;
            
            @weakify(self);
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self);
                [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self).offset((kDefaultPlace + self.spaceOffset) / 2 + sender.frame.origin.x);
                    make.width.mas_equalTo(sender.width - kDefaultPlace - self.spaceOffset);
                }];
                [self layoutIfNeeded];
                
                if (sender.centerX >= KScreenWidth / 2 && sender.centerX <= self.contentSize.width - KScreenWidth / 2) {
                    self.contentOffset = CGPointMake(sender.centerX - KScreenWidth / 2, 0);
                }else if (sender.centerX <  KScreenWidth / 2) {
                    self.contentOffset = CGPointMake(0, 0);
                }else if (sender.centerX > self.contentSize.width - KScreenWidth / 2) {
                    self.contentOffset = CGPointMake(self.contentSize.width - KScreenWidth, 0);
                }
            }];
        }else {
            button.selected = NO;
        }
    }
}

@end
