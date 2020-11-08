//
//  BaseModel+Practise.m
//  practice
//
//  Created by 张浩 on 2020/10/25.
//
/**
 * Category的方法是在运行过程中动态加入到元类和类对象中的，分类在编译完成之后每个分类会生成一个 struct _category_t 这种类型的结构体
 * struct _category_t 中包含:分类name 实力对象struct _method_list_t 类对象 struct method_list  代理 struct protocal_list_t 属性 _prop_list_t
 * runtime的时候会合并分类和本类的各个数组，后面参与编译的方法会被放在最前面，
 */
#import "BaseModel+Practise.h"
#import <objc/runtime.h>
@implementation BaseModel (Practise)

static const char ZHExerciseNameKey = '\0';
- (void)setExerciseName:(NSString *)exerciseName
{
    NSLog(@"%p",&ZHExerciseNameKey);
    if (exerciseName != self.exerciseName) {
        // 存储新的
        objc_setAssociatedObject(self, &ZHExerciseNameKey,
                                 exerciseName, OBJC_ASSOCIATION_RETAIN);
    }
}

- (NSString *)exerciseName
{
    return objc_getAssociatedObject(self, &ZHExerciseNameKey);
}

-(void)exercise{
    NSLog(@"%s",__FUNCTION__);
}
+(void)load
{
    NSLog(@"%s",__FUNCTION__);
}
+(void)initialize
{
    NSLog(@"%s",__FUNCTION__);
}
@end
