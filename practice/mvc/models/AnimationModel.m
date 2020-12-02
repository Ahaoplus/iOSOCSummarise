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
          @{@"key":@"key1",@"title":@"HTTPS",@"icon":@"",@"authCode":@""},
          @{@"key":@"key2",@"title":@"TCP协议",@"icon":@"",@"authCode":@""},
          @{@"key":@"key3",@"title":@"IP协议",@"icon":@"",@"authCode":@""},
          @{@"key":@"key4",@"title":@"UDP协议",@"icon":@"",@"authCode":@""},
          @{@"key":@"key5",@"title":@"Socket编程",@"icon":@"",@"authCode":@""}
    ];
}
@end
