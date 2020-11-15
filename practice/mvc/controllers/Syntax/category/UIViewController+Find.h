//
//  UIViewController+Find.h
//  practice
//
//  Created by 张浩 on 2020/11/15.
//  获取根vc和当前vc

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Find)
+(UIViewController*)find_rootViewController;
+(UIViewController*)find_currentViewController;
@end

NS_ASSUME_NONNULL_END
