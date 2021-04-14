//
//  BaseModel.m
//  practice
//
//  Created by 张浩 on 2020/9/23.
//

#import "BaseModel.h"
@interface BaseModel()
//匿名分类，但严格意义上来讲其实就叫类扩展，你必须有源码，在m文件中
//编译的时候就会和类的各个方法列表和属性列表等合并
@end
@implementation BaseModel
//类被使用的时候才会调用
+(void)initialize
{
//    if(self == [BaseModel class])
//    {
        NSLog(@"%s",__FUNCTION__);
//    }
}
//在main函数之前就有调用了
+(void)load
{
    NSLog(@"%s",__FUNCTION__);
}
@end
