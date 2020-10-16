//
//  UIViewController+Normal.h
//  practice
//
//  Created by 张浩 on 2020/10/8.
//  不同的分类中声明的函数最好都加上前缀，否则同一个类的不同分类有不同的方法，调用这个方法会是未知的。
/**
 *
 *Category 是一种很灵活的扩展原有类的机制，使用 Category 不需要访问原有类的代码，也无需继承。Category提供了一种简单的方式，来实现类的相关方法的模块化，把不同的类方法分配到不同的类文件中。
 *在使用 Category 时需要注意的一点是，如果有多个命名 Category 均实现了同一个方法（即出现了命名冲突），那么这些方法在运行时只有一个会被调用，具体哪个会被调用是不确定的。因此在给已有的类（特别是 Cocoa 类）添加 Category 时，推荐的函数命名方法是加上前缀：
 *
 
 

 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Normal)
+(void)normal_thisIsAStaticMethod; // 静态方法

-(void)normal_thisIsAnInstanceMethod; // 实例方法

@end

NS_ASSUME_NONNULL_END
