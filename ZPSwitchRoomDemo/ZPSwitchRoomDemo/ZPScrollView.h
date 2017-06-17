//
//  ZPScrollView.h
//  ZPSwitchRoomDemo
//
//  Created by mars on 2017/6/17.
//  Copyright © 2017年 ZhaoPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPScrollView : UIView

/**
 初始化
 @param dataArray 所要滚动的数据（这里我们模仿在直播间切换房间的场景，那么这里就是所有的主播列表数据）
 */
- (instancetype)initWithScrollDataArray:(NSArray *)dataArray;

@end
