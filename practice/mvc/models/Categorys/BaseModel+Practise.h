//  在分类中给类添加成员变量：直接添加不可以，是该使用runtime
//  BaseModel+Practise.h
//  practice
//
//  Created by 张浩 on 2020/10/25.
//

#import "BaseModel.h"
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface BaseModel (Practise)
/*
 分类不能直接添加成员变量，可以添加属性，但需要特殊处理
 直接添加属性运行调用此属性则报错：
 libc++abi.dylib: terminating with uncaught exception of type NSException
 *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[TestModel exerciseName]: unrecognized selector sent to instance 0x6000033b16b0'
 */
@property(nonatomic,strong) NSString* exerciseName;
@property(nonatomic,assign) int count;
-(void)exercise;
@end

NS_ASSUME_NONNULL_END
/**
 很多人认为交换方法实现会带来无法预料的结果。然而采取了以下预防措施后, method swizzling 会变得很可靠：

 在交换方法实现后记得要调用原生方法的实现（除非你非常确定可以不用调用原生方法的实现）：APIs 提供了输入输出的规则，而在输入输出中间的方法实现就是一个看不见的黑盒。交换了方法实现并且一些回调方法不会调用原生方法的实现这可能会造成底层实现的崩溃。
 避免冲突：为分类的方法加前缀，一定要确保调用了原生方法的所有地方不会因为你交换了方法的实现而出现意想不到的结果。
 理解实现原理：只是简单的拷贝粘贴交换方法实现的代码而不去理解实现原理不仅会让 App 很脆弱，并且浪费了学习 Objective-C 运行时的机会。阅读 Objective-C Runtime Reference 并且浏览 <obje/runtime.h> 能够让你更好理解实现原理。
 持续的预防：不管你对你理解 swlzzling 框架，UIKit 或者其他内嵌框架有多自信，一定要记住所有东西在下一个发行版本都可能变得不再好使。做好准备，在使用这个黑魔法中走得更远，不要让程序反而出现不可思议的行为。
 */

