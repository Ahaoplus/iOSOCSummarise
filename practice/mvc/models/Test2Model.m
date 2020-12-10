//
//  Test2Model.m
//  practice
//
//  Created by 张浩 on 2020/10/25.
//

#import "Test2Model.h"

@implementation Test2Model
+(void)initialize
{
    NSLog(@"%s",__FUNCTION__);
}
+(void)load{
    NSLog(@"%s",__FUNCTION__);
}
-(void)testMethodForwarding{
    NSLog(@"TestModel转发给Test2Model函数调用消息转发成功");
}
@end
