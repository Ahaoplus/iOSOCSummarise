//
//  UIViewController+Attributes.m
//  practice
//
//  Created by 张浩 on 2020/10/8.
//

#import "UIViewController+Attributes.h"
#import <objc/runtime.h>

static char kAssociatedObjectKey;
@implementation UIViewController (Attributes)
@dynamic associatedObject;
- (void)setAssociatedObject:(id)object {
    //运行时添加属性
     objc_setAssociatedObject(self, @selector(associatedObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObject {
    objc_getAssociatedObject(self, &kAssociatedObjectKey);
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

/*
 通常推荐的做法是添加的属性最好是 static char 类型的，当然更推荐是指针型的。通常来说该属性应该是常量、唯一的、在适用范围内用getter和setter访问到：
 */
@end
