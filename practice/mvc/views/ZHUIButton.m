//
//  ZHUIButton.m
//  practice
//
//  Created by 张浩 on 2020/10/28.
//

#import "ZHUIButton.h"

@implementation ZHUIButton
//扩大button点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(CGRectInset(self.bounds, -20, -20), point)) {
        return YES;
    }
    return NO;
}
/**
 2 子view超出了父view的bounds响应事件
 正常情况下，子View超出父View的bounds的那一部分是不会响应事件的
 解决方法:重写父View的pointInside方法

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL flag = NO;
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(view.frame, point)){
            flag = YES;
            break;
        }
    }
    return flag;
}
*/

/**
 *
 *
 - (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
 {
     BOOL next = YES;
     for (UIView *view in self.subviews) {
         if ([view isKindOfClass:[UIControl class]]) {
             if (CGRectContainsPoint(view.frame, point)){
                 next = NO;
                 break;
             }
         }
     }
     return !next;
 }
 
 */

/**
 点击View本身Button会响应该事件，点击View的任何一个子View，Button不会响应事件


 - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
 {
     UIView *view = [super hitTest:point withEvent:event];
     if (view == self) {
         return nil;
     }
     return view;
 }

 
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
