//
//  TestModel.m
//  practice
//
//  Created by 张浩 on 2020/10/25.
//

#import "TestModel.h"
#import "Test2Model.h"
#import <objc/runtime.h>
@implementation TestModel
@dynamic age;
- (instancetype)init
{
    self = [super init];
    if (self) {
        //[self class] is TestModel
        NSLog(@"[self class] is %@",[self class]);
        NSLog(@"[TestModel class] is %@",[TestModel class]);
        
        //[super class] is TestModel
        NSLog(@"[super class] is %@",[super class]);
        //[self superclass] is BaseModel
        NSLog(@"[self superclass] is %@",[self superclass]);
        //[super superclass] is BaseModel
        NSLog(@"[super superclass] is %@",[super superclass]);
        NSLog(@"[TestModel superclass] is %@",[TestModel superclass]);
    }
    return self;
}
void setAge(id self ,SEL _cmd, int age){
    NSLog(@"%d",age);
}
int age(id self ,SEL _cmd){
    return 120;
}
+(void)initialize
{
    NSLog(@"%s",__FUNCTION__);
}
/// 1、receiverClaas的cache 中查找方法找不到则从class_rw_t中查找方法 没找到则superclass中查找
/// 2、动态方法解析：如果没有此方法则添加此方法，如下范例就是给NSNumber动态添加NSString的一些方法
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    if(sel == @selector(setAge:)){
        class_addMethod([self class], sel, (IMP)setAge, "v@:i");
        return  YES;
    }else if (sel == @selector(age)){
        class_addMethod([self class], sel, (IMP)age, "i@:v");
        return  YES;
    }
    else if ([NSStringFromSelector(sel) isEqualToString:@"length"])
    {
        class_addMethod([self class], sel, (IMP)myLengthMethod, "Q@:v");
        return  YES;

    }else if([NSStringFromSelector(sel) isEqualToString:@"isEqualToString:"]){
        class_addMethod([self class], sel, (IMP)myLengthMethod, "B@:@");
        return  YES;
    }
    else{
        NSLog(@"*****can‘t find method %@ but super is %@",NSStringFromSelector(sel),NSStringFromClass([super class]));
    }

    return [super resolveInstanceMethod:sel];
}
NSUInteger myLengthMethod(id self,SEL _cmd){

    NSLog(@"*****error method %@",NSStringFromSelector(_cmd));
    return [[NSString stringWithFormat:@"%@",self] length];
}

BOOL myEqualMethod(id self,SEL _cmd,NSString* str){

    NSLog(@"*****error method %@ with str",NSStringFromSelector(_cmd));
    return [[NSString stringWithFormat:@"%@",self] isEqualToString:str];
}


/***************************3、消息转发：转发给另外一个对象去处理消息******************/
- (id)forwardingTargetForSelector:(SEL)aSelector{
    //如果Test2Model实现了aSelector 则成功，否则会报异常
    //return [[Test2Model alloc] init];
    return nil;//此种情形会调用methodSignatureForSelector
}
//类方法处理
+(id)forwardingTargetForSelector:(SEL)aSelector{
    //如果Test2Model实现了aSelector 则成功，否则会报异常
    return [Test2Model class];
    return nil;//此种情形会调用methodSignatureForSelector
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSLog(@"%s",@encode(void));
    
    if (aSelector == @selector(testMethodForwarding)) {
        NSString* astr = [NSString stringWithUTF8String:@encode(void)];
        NSString* bstr = [NSString stringWithUTF8String:@encode(SEL)];
        NSString* cstr = [NSString stringWithUTF8String:@encode(int)];
        
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:i"];
        return signature;
        //如果知道某个对象实现了这个方法则调用他的这个方法可以得到签名，否则得自己写
        return [[[Test2Model alloc]init] methodSignatureForSelector:aSelector];
    }
    //返回nil则代表不处理
    return [super methodSignatureForSelector:aSelector];
    
}
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSLog(@"%s",@encode(void));
    
    if (aSelector == @selector(testMethodForwarding)) {
        NSString* astr = [NSString stringWithUTF8String:@encode(void)];
        NSString* bstr = [NSString stringWithUTF8String:@encode(SEL)];
        NSString* cstr = [NSString stringWithUTF8String:@encode(int)];
        
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:i"];
        return signature;
        //如果知道某个对象实现了这个方法则调用他的这个方法可以得到签名，否则得自己写
        return [[[Test2Model alloc]init] methodSignatureForSelector:aSelector];
    }
    //返回nil则代表不处理
    return [super methodSignatureForSelector:aSelector];
    
}
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"%@",anInvocation);
}
+(void)forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"%@",anInvocation);
}
@end
