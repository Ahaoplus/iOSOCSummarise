//
//  UIView+ZHVC.m
//  practice
//
//  Created by 张浩 on 2020/10/28.
//

#import "UIView+ZHVC.h"

@implementation UIView (ZHVC)
- (UIViewController *)viewController_V1
{
    UIViewController *viewController=nil;
    UIView* next = [self superview];
    UIResponder *nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        viewController = (UIViewController *)nextResponder;
    }
    else
    {
        viewController = [next viewController];
    }
    return viewController;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
