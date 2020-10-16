/*
 *https://nshipster.cn/method-swizzling/
 *Method Swizzling
 *
 *Method swizzling 用于改变一个已经存在的 selector 的实现。这项技术使得在运行时通过改变 selector 在类的消息分发列表中的映射从而改变方法的掉用成为可能。例如：我们想要在一款 iOS app 中追踪每一个视图控制器被用户呈现了几次： 这可以通过在每个视图控制器的 viewDidAppear: 方法中添加追踪代码来实现，但这样会大量重复的样板代码。继承是另一种可行的方式，但是这要求所有被继承的视图控制器如 UIViewController, UITableViewController, UINavigationController 都在 viewDidAppear：实现追踪代码，这同样会造成很多重复代码。 幸运的是，这里有另外一种可行的方式：从 category 实现 method swizzling 。下面是实现方式：
*/
//  UIViewController+Tracking.h
//  practice
//
//  Created by 张浩 on 2020/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Tracking)

@end

NS_ASSUME_NONNULL_END
