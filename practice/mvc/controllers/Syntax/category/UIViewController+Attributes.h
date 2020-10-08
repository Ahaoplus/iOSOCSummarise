//
//  UIViewController+Attributes.h
//  practice
//
//  Created by 张浩 on 2020/10/8.
//
/**
 Objective-C开发者应该小心谨慎地遵循这个危险咒语的各种准则。一个很好的原因的就是：混乱的运行时代码会改变运行在其架构之上的所有代码。

 从利的角度来讲， <objc/runtime.h> 中的函数具有其他方式做不到的、能为应用和框架提供强大功能的能力。而从弊的角度来讲，它可能会会毁掉代码的sanity meter，一切代码和逻辑都可能被异常糟糕的副作用影响(terrifying side-effects)。

 因此，我们怀着巨大的恐惧来思考这个与“魔鬼的交易”(Faustian bargain)，一起来看看这个最多地被NSHipster读者们要求讲讲的主题之一：对象关联（associated objects）。

 对象关联（或称为关联引用）本来是Objective-C 2.0运行时的一个特性，起始于OS X Snow Leopard和iOS 4。相关参考可以查看 <objc/runtime.h> 中定义的以下三个允许你将任何键值在运行时关联到对象上的函数：

 objc_setAssociatedObject  用set nil来remove
 objc_getAssociatedObject
 objc_removeAssociatedObjects 开发者最好不用这个方法来remove属性
 为什么我说这个很有用呢？因为这允许开发者对已经存在的类在扩展中添加自定义的属性，这几乎弥补了Objective-C最大的缺点。


 
 优秀样例
 添加私有属性用于更好地去实现细节。当扩展一个内建类的行为时，保持附加属性的状态可能非常必要。注意以下说的是一种非常_教科书式_的关联对象的用例：AFNetworking在 UIImageView 的category上用了关联对象来保持一个operation对象，用于从网络上某URL异步地获取一张图片。
 添加public属性来增强category的功能。有些情况下这种(通过关联对象)让category行为更灵活的做法比在用一个带变量的方法来实现更有意义。在这些情况下，可以用关联对象实现一个一个对外开放的属性。回到上个AFNetworking的例子中的 UIImageView category，它的 imageResponseSerializer方法允许图片通过一个滤镜来显示、或在缓存到硬盘之前改变图片的内容。
 创建一个用于KVO的关联观察者。当在一个category的实现中使用KVO时，建议用一个自定义的关联对象而不是该对象本身作观察者。
 
 
 反例
 当值不需要的时候建立一个关联对象。一个常见的例子就是在view上创建一个方便的方法去保存来自model的属性、值或者其他混合的数据。如果那个数据在之后根本用不到，那么这种方法虽然是没什么问题的，但用关联到对象的做法并不可取。
 当一个值可以被其他值推算出时建立一个关联对象。例如：在调用 cellForRowAtIndexPath: 时存储一个指向view的 UITableViewCell 中accessory view的引用，用于在 tableView:accessoryButtonTappedForRowWithIndexPath: 中使用。
 用关联对象替代X，这里的X可以代表下列含义：
 当继承比扩展原有的类更方便时用子类化。
 为事件的响应者添加响应动作。
 当响应动作不方便使用时使用的手势动作捕捉。
 行为可以在其他对象中被代理实现时要用代理(delegate)。
 用NSNotification 和 NSNotificationCenter进行松耦合化的跨系统的事件通知。
 比起其他解决问题的方法，关联对象应该被视为最后的选择（事实上category也不应该作为首选方法）。

 和其他精巧的trick、hack、workaround一样，一般人都会在刚学习完之后乐于寻找场景去使用一下。尽你所能去理解和欣赏它在正确使用时它所发挥的作用，同时当你选择_这个_解决办法时，也要避免当被轻蔑地问起“这是个什么玩意？”时的尴尬。
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Attributes)
@property (nonatomic, strong) id associatedObject;
@end

NS_ASSUME_NONNULL_END
