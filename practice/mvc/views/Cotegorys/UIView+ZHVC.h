//
//  UIView+ZHVC.h
//  practice
//
//  Created by 张浩 on 2020/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZHVC)
//返回当前view所属的viewcontroller
- (UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
