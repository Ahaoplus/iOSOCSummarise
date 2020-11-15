//
//  UIViewController+Find.m
//  practice
//
//  Created by 张浩 on 2020/11/15.
//

#import "UIViewController+Find.h"

@implementation UIViewController (Find)
+(UIViewController*)find_rootViewController{
    UIWindow* window =[[[UIApplication sharedApplication] delegate] window];
    NSAssert(window==nil, @"当前window为空！");
    return window.rootViewController;
}
+(UIViewController*)find_currentViewControllerWithVC:(UIViewController*)vc{
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [UIViewController find_currentViewControllerWithVC:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController find_currentViewControllerWithVC:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController find_currentViewControllerWithVC:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController find_currentViewControllerWithVC:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
}
+(UIViewController*)find_currentViewController{
    
    return [self find_currentViewControllerWithVC:[self find_rootViewController]];
}
@end
