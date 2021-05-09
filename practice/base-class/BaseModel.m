//
//  BaseModel.m
//  practice
//
//  Created by 张浩 on 2020/9/23.
//

#import "BaseModel.h"
/*
 @protocol NSCopying

 - (id)copyWithZone:(nullable NSZone *)zone;

 @end

 @protocol NSMutableCopying

 - (id)mutableCopyWithZone:(nullable NSZone *)zone;

 @end
 */
@interface BaseModel()<NSCopying,NSMutableCopying>
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
//load 是直接调用的IMP即函数指针，而initialize调用的是SEL 函数名调用，会被分类覆盖，子类被第一次使用的时候会如果没实现initialize，而父类实现了则会调用两次父类的initialize
+(void)load
{
    NSLog(@"%s",__FUNCTION__);
}
/*
 singleChild被copy修饰，会调用copy函数，如果没有实现该协议则汇报下面错误
 *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[BaseModel copyWithZone:]: unrecognized selector sent to instance 0x281299b40'
 terminating with uncaught exception of type NSException
 */
-(void)testCopy{
    self.singleChild = [[BaseModel alloc]init];
    NSLog(@"%@",self.singleChild);
    
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    BaseModel* model  = [[[self class] allocWithZone:zone] init];
    model.name = [self.name copy];
    model.singleChild = [self.singleChild copy];
    return model;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    BaseModel* model  = [[[self class] allocWithZone:zone] init];
    model.name = [self.name copy];
    model.singleChild = [self.singleChild copy];
    return model;
}

@end
