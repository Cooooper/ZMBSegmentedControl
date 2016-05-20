
//
//  Created by zmb on 15/7/1.
//  Copyright (c) 2015年 zmb. All rights reserved.
//

#import "ZMBSegmentedControl.h"

static CGFloat        kUnderlineHeight            = 2.5;
static NSTimeInterval kUnderlineAnimationDuration = 0.2;

@interface ZMBSegmentedControl ()

@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) UIButton       *selectedButton;

@property (nonatomic,strong) UIView *underline;

@end

@implementation ZMBSegmentedControl

- (instancetype)init
{
  self = [super init];
  if (!self) { return nil; }
  
  self.buttons = [NSMutableArray array];
  
  self.titleColor             = [UIColor grayColor];
  self.hightlightedTitleColor = [UIColor blueColor];
  self.underlineColor         = [UIColor blueColor];
  
  self.underline = [[UIView alloc] init];
  self.underline.backgroundColor = self.underlineColor;
  [self addSubview:self.underline];
  
  return self;
}

#pragma mark -
#pragma mark Properties

- (void)setTitles:(NSArray *)titles
{
  _titles = titles;
  
  [self.buttons removeAllObjects];
  
  NSInteger cnt = titles.count;
  
  for (int i = 0; i < cnt; i++) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:i];
    [button setTitle:titles[i] forState:UIControlStateNormal];
    [button setTitleColor:self.titleColor forState:UIControlStateNormal];
    [button setTitleColor:self.hightlightedTitleColor forState:UIControlStateHighlighted];
    [button setTitleColor:self.hightlightedTitleColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [[button titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:button];
    
    [self.buttons addObject:button];
  }
  
  for (int i = 0; i < cnt; i++) {
    UIButton *button      = self.buttons[i];
    UIButton *leftButton  = nil;
    UIButton *rightButton = nil;

    if (i > 0) {
      leftButton = self.buttons[i - 1];
    }
    if (i < cnt - 1) {
      rightButton = self.buttons[i + 1];
    }
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.and.bottom.equalTo(self);
      make.width.equalTo(self.buttons);
      
      if (leftButton && rightButton) {
        make.left.equalTo(leftButton.right);
        make.right.equalTo(rightButton.left);
      }
      else if (leftButton) {
        make.left.equalTo(leftButton.right);
        make.right.equalTo(self.right);
      }
      else if (rightButton) {
        make.left.equalTo(self.left);
        make.right.equalTo(rightButton.left);
      }
      else {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
      }
    }];
  }
  
//  UILabel *line = [[UILabel alloc] init];
//  line.backgroundColor = self.titleColor;
//  [self addSubview:line];
//  
//  [line makeConstraints:^(MASConstraintMaker *make) {
//    make.left.right.bottom.equalTo(self);
//    make.height.equalTo(0.3);
//    
//  }];
  
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
  NSAssert(selectedIndex < self.buttons.count, @"'selectedIndex' is beyond titles.count.");
  [self setSelectedIndex:selectedIndex animdated:NO];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animdated:(BOOL)animated
{
  _selectedIndex = selectedIndex;
  self.selectedButton.selected = NO;
  self.selectedButton = self.buttons[selectedIndex];
  self.selectedButton.selected = YES;
    [self setNeedsUpdateConstraints];
  [self updateConstraintsIfNeeded];

  if (animated) {
    [UIView animateWithDuration:kUnderlineAnimationDuration animations:^{
      [self layoutIfNeeded];
    }];
  }
}

- (void)setTitleColor:(UIColor *)titleColor
{
  _titleColor = titleColor;
  for (UIButton *button in self.buttons) {
    [button setTitleColor:titleColor forState:UIControlStateNormal];
  }
}

- (void)setHightlightedTitleColor:(UIColor *)hightlightedTitleColor
{
  _hightlightedTitleColor = hightlightedTitleColor;
  for (UIButton *button in self.buttons) {
    [button setTitleColor:hightlightedTitleColor forState:UIControlStateHighlighted];
    [button setTitleColor:hightlightedTitleColor forState:UIControlStateSelected];
  }
}

- (void)setUnderlineColor:(UIColor *)underlineColor
{
  _underlineColor = underlineColor;
  self.underline.backgroundColor = underlineColor;
}

- (void)setUnderlineLength:(CGFloat)underlineLength
{
  _underlineLength = underlineLength;
  if (self.selectedButton) {
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
  }
}

#pragma mark -
#pragma mark Button Event

- (void)buttonDidPress:(UIButton *)button
{
//  [self setSelectedIndex:button.tag animdated:YES];
  [self setSelectedIndex:button.tag animdated:NO];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
  if (self.segmentedControlDidSelectedAtIndex) {
    self.segmentedControlDidSelectedAtIndex(button.tag);
  }
  
  if ([self.delegate respondsToSelector:@selector(segmentedControl:didSelectedAtIndex:)]) {
    [self.delegate segmentedControl:self didSelectedAtIndex:button.tag];
  }
}

#pragma mark -
#pragma mark update constraints

- (void)updateConstraints
{
  [self.underline remakeConstraints:^(MASConstraintMaker *make) {
    if (self.selectedButton) {
      make.centerX.equalTo(self.selectedButton.centerX);
      make.width.equalTo(self.underlineLength);
      make.height.equalTo(kUnderlineHeight);
      make.bottom.equalTo(self.bottom);
    }
    else {
      make.top.and.bottom.and.left.and.right.equalTo(0);
    }
  }];
  
  [super updateConstraints];
}

@end
