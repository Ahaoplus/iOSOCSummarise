//
//  ZHUIView.m
//  practice
//
//  Created by 张浩 on 2020/10/28.
//

#import "ZHUIView.h"

@implementation ZHUIView
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    UIResponder * next = [self nextResponder];
    NSMutableString * prefix = @"".mutableCopy;

    while (next != nil) {
        NSLog(@"%@%@", prefix, [next class]);
        [prefix appendString: @"--"];
        next = [next nextResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //如果- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event函数返回YES则view为nil
    UIView *view = [super hitTest:point withEvent:event];
    int i = 0;
    if (view == nil ) {
        //遍历当前view的subView，看一下被触摸的点是否在subView上
        if (self.subviews.count>0) {
            for (UIView *subView in self.subviews) {
                CGPoint tp = [subView convertPoint:point fromView:self];
                if (CGRectContainsPoint(subView.bounds, tp)) {
                    view = subView;
                    NSLog(@"%d-------------+++++++++++++++++++++%@",i,subView);
                }
                i++;
            }
        }
        NSLog(@"%d-------------+++++++++++++++++++++self is %@ event is %@",i,self,event);
    }else{
         NSLog(@"%d-----not null--------%@ event is %@ point is (%f,%f)",i,self,event,point.x,point.y);
    }
    //如果为nil则认为当前view和其subview都不包含被触碰的点

    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
