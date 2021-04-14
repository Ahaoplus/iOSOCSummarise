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
    
    BOOL success = class_addMethod(class,
                                   originalSelector,
                                   method_getImplementation(swizzledMethod),
                                   method_getTypeEncoding(swizzledMethod));
    if (success) {
        //将某一个类中某个方法的IMP和types替换成另一个方法的IMP和types，只是一个类中的方法实现改变了而不是两个方法实现的替换。
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else {
        //直接替换掉两个方法中的IMP，即方法的具体实现。
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIView (Responder)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([UIView class], @selector(touchesBegan:withEvent:), @selector(ds_touchesBegan:withEvent:));
        swizzling_exchangeMethod([UIView class], @selector(touchesMoved:withEvent:), @selector(ds_touchesMoved:withEvent:));
        swizzling_exchangeMethod([UIView class], @selector(touchesEnded:withEvent:), @selector(ds_touchesEnded:withEvent:));
    });
}


#pragma mark -
//https://zhangbuhuai.com/post/swizzle-problem.html
/*
 对touch swizzled会出现崩溃，因为并不是每个UIResponser
 为啥 TestView 对touchesBegan:withEvent:方法进行 override 就可以解决问题呢？
 因为，即便代码走到f1处，_cmd变成了@selector(rac_alias_touchesBegan:withEvent:)，f2处的显式调用也能确保逻辑走到UIResponder的touchesBegan:withEvent:时，_cmd恢复成@selector(touchesBegan:withEvent:)。
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
}
- (void)ds_touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
    NSLog(@"%@ touch begin", self.class);
    
    if ([self respondsToSelector:@selector(ds_touchesBegan:withEvent:)]) {
        [self ds_touchesBegan:touches withEvent:event];
    }
//    else if ([self respondsToSelector:@selector(touchesBegan:withEvent:)]) {
//        [self touchesBegan:touches withEvent:event];
//    }
//这里会导致点击失效，因为事件会一直往下传递
//    UIResponder *next = [self nextResponder];
//    while (next) {
//        NSLog(@"%@",next.class);
//        next = [next nextResponder];
//    }
}

- (void)ds_touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
    NSLog(@"%@ touch move", self.class);
    if ([self respondsToSelector:@selector(ds_touchesMoved:withEvent:)]) {
        [self ds_touchesMoved:touches withEvent:event];
    }
//    else if ([self respondsToSelector:@selector(touchesMoved:withEvent:)]) {
//        [self touchesMoved:touches withEvent:event];
//    }

}

- (void)ds_touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event
{
    NSLog(@"%@ touch end", self.class);
    if ([self respondsToSelector:@selector(ds_touchesEnded:withEvent:)]) {
        [self ds_touchesEnded:touches withEvent:event];
    }
//    else if ([self respondsToSelector:@selector(touchesEnded:withEvent:)]) {
//        [self touchesEnded:touches withEvent:event];
//    }

}
@end
