
//
//  Created by zmb on 15/7/1.
//  Copyright (c) 2015年 zmb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZMBSegmentedControl;

@protocol ZMBSegmentedControlDelegate <NSObject>

- (void)segmentedControl:(ZMBSegmentedControl *)segmentControl didSelectedAtIndex:(NSInteger)selectedIndex;

@end

@interface ZMBSegmentedControl : UIControl

- (instancetype)init;

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,assign) NSUInteger selectedIndex;

@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIColor *hightlightedTitleColor;

@property (nonatomic,strong) UIColor *underlineColor;
@property (nonatomic,assign) CGFloat  underlineLength;

@property (nonatomic,copy) void(^segmentedControlDidSelectedAtIndex)(NSInteger selectedIndex); //index从0开始

@property (nonatomic,weak) id <ZMBSegmentedControlDelegate> delegate;



@end
