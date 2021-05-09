//
//  AnimationModel.m
//  practice
//
//  Created by 张浩 on 2020/12/2.
//

#import "AnimationModel.h"

@implementation AnimationModel
+(NSArray*)getAnimationModels{
    return @[
        @{@"key":@"0",@"target":@"ImageShowerViewController",@"title":@"图片预览",@"icon":@"",@"authCode":@""},
        @{@"key":@"1",@"target":@"ZHGPUViewController",@"title":@"CPU渲染相关",@"icon":@"",@"authCode":@""},
        @{@"key":@"2",@"target":@"RQShineDemoViewController",@"title":@"CADisplayLink动画字",@"icon":@"",@"authCode":@""},
        @{@"key":@"3",@"target":@"ZHSDWebImageViewController", @"title":@"SDWebImage",@"icon":@"",@"authCode":@""},
        @{@"key":@"4",@"target":@"FriendsCircleViewController",@"title":@"朋友圈九宫格",@"icon":@"",@"authCode":@""},
        @{@"key":@"5",@"target":@"ZHRecardWaverViewController",@"title":@"录音声波Waver",@"icon":@"",@"authCode":@""},
        @{@"key":@"6",@"target":@"ZHWalletViewController",@"title":@"可甜卡包",@"icon":@"",@"authCode":@""},
        @{@"key":@"7",@"target":@"FriendsCircleViewController",@"title":@"MJRefresh",@"icon":@"",@"authCode":@""},
        @{@"key":@"8",@"target":@"FriendsCircleViewController",@"title":@"RKNotificationHub",@"icon":@"",@"authCode":@""},
    ];
}
@end
