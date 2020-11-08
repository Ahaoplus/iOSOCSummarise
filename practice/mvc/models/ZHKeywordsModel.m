//
//  ZHKeywordsModel.m
//  practice
//
//  Created by 张浩 on 2020/10/7.
//

#import "ZHKeywordsModel.h"


@implementation ZHKeywordsModel
/*
 2020-10-25 21:48:37.263494+0800 practice[33497:756733] +[BaseModel(Test) initialize] 父类的分类会覆盖父类的initialize
 2020-10-25 21:48:37.263649+0800 practice[33497:756733] +[ZHKeywordsModel initialize] 子类
 2020-10-25 21:48:37.263777+0800 practice[33497:756733] +[ZHKeywordsModel new]
 2020-10-25 21:48:37.263910+0800 practice[33497:756733] +[ZHKeywordsModel alloc]
 2020-10-25 21:48:37.264034+0800 practice[33497:756733] -[ZHKeywordsModel init]
 */
-(void)print{
    NSLog(@"my name's %@",self.strCopy);
}
-(instancetype)init{
    //_cmd 默认的当前方法的指针，每个方法都有一些默认的参数，只是被隐藏了
    NSLog(@"%s",__FUNCTION__);//_cmd当前方法
    NSLog(@"--------------------------------------------");
    if (self = [super init]) {
        NSLog(@"[self class] %@",[self class]);
        NSLog(@"[super class] %@",[super class]);
        NSLog(@"[self superclass] %@",[self superclass]);
        NSLog(@"[super superclass] %@",[super superclass]);
        
        NSLog(@"--------------------------------------------");
        
        BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]]; // 元类的类型还是NSObject
        BOOL res2 = [[[NSObject alloc]init] isMemberOfClass:[NSObject class]];
        BOOL res3 = [[ZHKeywordsModel class] isKindOfClass:[ZHKeywordsModel class]];
        BOOL res4 = [[ZHKeywordsModel class] isMemberOfClass:[ZHKeywordsModel class]];
        
        NSLog(@"%d %d %d %d",res1,res2,res3,res4);
        
        NSLog(@"--------------------------------------------");
        
    }
    return self ;
}
+(instancetype)alloc{
    NSLog(@"%s",__FUNCTION__);
    return [super alloc];
}
+(instancetype)new{
    NSLog(@"%s",__FUNCTION__);
    return [super new];
}

//第一次被使用（这个类第一次接收到消息的时候调用和消息机制调用的）的时候才会调用，只调用一次
/**
 * id objc_msgSend(id self,SEL _cmd,...); //发送消息调用方法
 * IMP objc_msgLookup(id self,SEL _cmd,...); //查找方法
 * class_getInstanceMethod class_getClassMethod
 *分类中的initialize会覆盖类中的initialize，先调用父类（或者父类的分类）然后调用子类
 *2020-10-25 20:34:03.755090+0800 practice[26898:707695] +[BaseModel(Test) initialize]
 *2020-10-25 20:34:03.755341+0800 practice[26898:707695] +[ZHKeywordsModel initialize]
 **/
+(void)initialize
{
//    if(self == [ZHKeywordsModel class])
//    {
              NSLog(@"%s",__FUNCTION__);
//    }
}


/**
 *为什么load方法都会调用？不会覆盖？他是加入到直接通过函数指针 调用的，不是通过objmessage调用的
 *在工程main函数之前调用 load  1、先按照编译顺序来顺序调用  类会先找父类，2、分类不会管父类还是子类，按编译顺序
 *2020-10-25 20:40:07.391050+0800 practice[27487:712730] +[BaseModel load] 父类
 *2020-10-25 20:40:07.392080+0800 practice[27487:712730] +[ZHKeywordsModel load] 子类
 *2020-10-25 20:40:07.392263+0800 practice[27487:712730] +[BaseModel(Practise) load] 父类的分类
 *2020-10-25 20:40:07.392376+0800 practice[27487:712730] +[BaseModel(Test) load] 父类的分类
 */
+(void)load
{
    NSLog(@"%s",__FUNCTION__);
}

@end
