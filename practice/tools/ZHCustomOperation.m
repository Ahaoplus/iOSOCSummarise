//
//  ZHCustomOperation.m
//  practice
//
//  Created by 张浩 on 2020/12/27.
//

#import "ZHCustomOperation.h"

@implementation ZHCustomOperation
-(void)main{
    NSLog(@"%s,thread is %@",__func__,[NSThread currentThread]);
}
-(void)dealloc{
    NSLog(@"%s ",__func__);
}
@end
