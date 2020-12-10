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
        @{@"key":@"key0",@"target":@"RQShineDemoViewController",@"title":@"CADisplayLink动画字",@"icon":@"",@"authCode":@""},
        @{@"key":@"key5",@"target":@"ZHSDWebImageViewController", @"title":@"SDWebImage",@"icon":@"",@"authCode":@""},
        @{@"key":@"key1",@"target":@"FriendsCircleViewController",@"title":@"朋友圈九宫格",@"icon":@"",@"authCode":@""},
        @{@"key":@"key2",@"target":@"ZHRecardWaverViewController",@"title":@"录音声波Waver",@"icon":@"",@"authCode":@""},
        @{@"key":@"key5",@"target":@"ZHWalletViewController",@"title":@"可甜卡包",@"icon":@"",@"authCode":@""},
        @{@"key":@"key3",@"target":@"FriendsCircleViewController",@"title":@"MJRefresh",@"icon":@"",@"authCode":@""},
        @{@"key":@"key4",@"target":@"FriendsCircleViewController",@"title":@"RKNotificationHub",@"icon":@"",@"authCode":@""},
    ];
}
@end
