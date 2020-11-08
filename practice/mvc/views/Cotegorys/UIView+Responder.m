//
//  UIView+Responder.m
//  practice
//
//  Created by 张浩 on 2020/10/28.
//

#import "UIView+Responder.h"
#import <objc/runtime.h>
static inline void swizzling_exchangeMethod(Class class ,SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIView (Responder)


+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        swizzling_exchangeMethod([UIView class], @selector(touchesBegan:withEvent:), @selector(ds_touchesBegan:withEvent:));
//        swizzling_exchangeMethod([UIView class], @selector(touchesMoved:withEvent:), @selector(ds_touchesMoved:withEvent:));
//        swizzling_exchangeMethod([UIView class], @selector(touchesEnded:withEvent:), @selector(ds_touchesEnded:withEvent:));
//    });
}


#pragma mark -

- (void)ds_touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
    NSLog(@"%@ touch begin", self.class);
    [self ds_touchesBegan:touches withEvent:event];
    if ([self respondsToSelector:@selector(ds_touchesBegan:withEvent:)]) {
        [self ds_touchesBegan:touches withEvent:event];
    }
//这里会导致点击失效，因为事件会一直往下传递
    UIResponder *next = [self nextResponder];
    while (next) {
        NSLog(@"%@",next.class);
        next = [next nextResponder];
    }
}
//
//- (void)ds_touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
//{
//    NSLog(@"%@ touch move", self.class);
//    if ([self respondsToSelector:@selector(ds_touchesMoved:withEvent:)]) {
//        [self ds_touchesMoved:touches withEvent:event];
//    }
//
//}
//
//- (void)ds_touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event
//{
//    NSLog(@"%@ touch end", self.class);
//    if ([self respondsToSelector:@selector(ds_touchesBegan:withEvent:)]) {
//        [self ds_touchesEnded:touches withEvent:event];
//    }else if ([self respondsToSelector:@selector(ds_touchesBegan:withEvent:)]){
//    }
//
//}
@end
