/*
 KVO
 copy深拷贝浅拷贝
 KVC使用 setValue:forKey:  int这类类型传NSNumber 依此类推  setValue:forKeyPath:@"cat.weight" ,复杂状况的

 
 */
//  ZHOOViewController.m
//  practice
//
//  Created by 张浩 on 2020/10/8.
//
/**
 *类的扩展——Protocol, Category 和 Extension
 *Protocol
 *OC是单继承的，OC中的类可以实现多个 protocol 来实现类似 C++ 中多重继承的效果。
 *Protocol 类似 Java 中的 interface，定义了一个方法列表，这个方法列表中的方法可以使用
 *@required， @optional 标注，以表示该方法是否是客户类必须要实现的方法。 一个 protocol 可以继承其他的 protocol 。
 *Delegate（委托）是 Cocoa 中常见的一种设计模式，其实现依赖于 protocol 这个语言特性。
 *当 Protocol 中含有 property 时，编译器是不会进行自动 synthesize 的，需要手动处理
 *在实现这个 Protocol 的时候，要么再次声明 property ;要么进行手动 synthesize.
 *工程自带的 AppDelegate 使用了前一种方法，UIApplicationDelegate protocol 当中定义了 window ; 在 AppDelegate.h 中我们可以看到再次对 windows 进行了声明：



 */
#import <objc/runtime.h>
#import "ZHOOViewController.h"
#import "UITextView+Utils.h"
#ifdef DEBUG
static NSString* const environmentName = @"测试环境";
#elif PRERELEASE
static NSString* const environmentName = @"预生产环境";
#else
static NSString* const environmentName = @"生产环境";
#endif
static NSString * const contentStr = @"1、@property 语法糖，自动实现getter setter方法;\n*readwrite 是可读可写特性；需要生成 getter 方法和 setter 方法\n*readonly 是只读特性，只会生成 getter 方法 不会生成 setter 方法，不希望属性在类外改变时使用\n*assign 是赋值特性，setter 方法将传入参数赋值给实例变量；仅设置变量时；\n*retain 表示持有特性，setter 方法将传入参数先保留，再赋值，传入参数的 retain count 会+1;\n*copy 表示拷贝特性，setter 方法将传入对象复制一份；需要完全一份新的变量时。\n*nonatomic 和 atomic ，决定编译器生成的 setter getter是否是原子操作。 atomic 表示使用原子操作，可以在一定程度上保证线程安全。一般推荐使用 nonatomic ，因为 nonatomic 编译出的代码更快\n*默认的 @property 是 readwrite，assign，atomic。\n*同时，我们还可以使用自己定义 accessor 的名字：\n@property (getter=isFinished) BOOL finished;\n这种情况下，编译器生成的 getter 方法名为 isFinished，而不是 finished。\n对于现代 OC 来说，在使用 @property 时， 编译器默认会进行自动 synthesize，生成 getter 和 setter，同时把 ivar 和属性绑定起来：\n\n2、@synthesize 和 @dynamic\n现代 OC 不再需要手动进行下面的声明，编译器会自动处理\n@synthesize propertyName = _propertyName\n然而并不是所有情况下编译器都会进行自动 synthesize，具体由下面几种：\n可读写(readwrite)属性实现了自己的 getter 和 setter\n只读(readonly)属性实现了自己的 getter\n使用 @dynamic，显式表示不希望编译器生成 getter 和 setter\nprotocol 中定义的属性，编译器不会自动 synthesize，需要手动写\n当重载父类中的属性时，也必须手动写 synthesize\n\n*类的扩展——Protocol, Category 和 Extension\n*Protocol\n*OC是单继承的，OC中的类可以实现多个 protocol 来实现类似 C++ 中多重继承的效果。\n*Protocol 类似 Java 中的 interface，定义了一个方法列表，这个方法列表中的方法可以使用\n*@required， @optional 标注，以表示该方法是否是客户类必须要实现的方法。 一个 protocol 可以继承其他的 protocol 。\n*Delegate（委托）是 Cocoa 中常见的一种设计模式，其实现依赖于 protocol 这个语言特性。\n*当 Protocol 中含有 property 时，编译器是不会进行自动 synthesize 的，需要手动处理\n*在实现这个 Protocol 的时候，要么再次声明 property ;要么进行手动 synthesize.\n*工程自带的 AppDelegate 使用了前一种方法，UIApplicationDelegate protocol 当中定义了 window ; 在 AppDelegate.h 中我们可以看到再次对 windows 进行了声明：";

/*此处即为类的扩展Extendtion
 Extension 可以认为是一种匿名的 Category， Extension 与 Category 有如下几点显著的区别：
 使用 Extension 必须有原有类的源码
 Extension 声明的方法必须在类的主 @implementation 区间内实现，可以避免使用有名 Category 带来的多个不必要的 implementation 段。
 Extension 可以在类中添加新的属性和实例变量，Category 不可以（注：在 Category 中实际上可以通过运行时添加新的属性，下面会讲到）
 Extension 里添加的方法必须要有实现（没有实现编译器会给出警告）
 注：现代 ObjC 中 Extension 和 Category 中声明的方法如果没有实现编译器都会给出警告
 
 
 */
@interface ZHOOViewController ()
/*
 Extension 很常见的用法，是用来给类添加私有的变量和方法，用于在类的内部使用。例如在 interface 中定义为 readonly 类型的属性，在实现中添加 extension，将其重新定义为 readwrite，这样我们在类的内部就可以直接修改它的值，然而外部依然不能调用 setter 方法来修改。
 Category像这样直接给类加属性是不行的，使用的时候会崩溃。需要使用runtime方法添加详情参见UIViewcontroller+Attributes类
 这样编译期就会报错：@synthesize not allowed in a category's implementation
 */
{
    NSString* name;
    NSString* _name;
    NSString* isName;
    NSString* _isName;
}
@property(readwrite)NSString* pageDescription;
@end

@implementation ZHOOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"类和对象";
    self->_isName = @"self->_isName";
    self->_name=@"self->_name";
    self->name=@"self->name";
    self->isName = @"self->isName";
    self.knowledgePoints = contentStr;
    
    // KVO监听之后isa的指向会变成NSKVONotifying_XXXClass(Runtime动态创建的)
    // p (IMP)0xddddd04383509 打印出方法实现  willChangeValueforKey didChangeValueForKey
    [self addObserver:self forKeyPath:@"pageDescription" options:NSKeyValueObservingOptionNew context:nil];
    
    [self printAllMethodOfClass:[self class]];
    
    /*NSKVONotifying_ZHOOViewController 动态生成的类继承自 ZHOOViewController
     -------------------------------------------
     2020-10-25 13:41:29.762412+0800 practice[89683:445440]  NSKVONotifying_ZHOOViewController setPageDescription:
     2020-10-25 13:41:29.762858+0800 practice[89683:445440]  NSKVONotifying_ZHOOViewController class
     2020-10-25 13:41:29.763258+0800 practice[89683:445440]  NSKVONotifying_ZHOOViewController dealloc
     2020-10-25 13:41:29.763607+0800 practice[89683:445440]  NSKVONotifying_ZHOOViewController _isKVOA
      -------------------------------------------
     iOS用什么方式实现对一个对象的KVO「本质」
         1、利用Runtime动态实现一个子类，并且让instance对象的isa指向这个全新的子类（这样它在寻找自己的方法的时候就会从全新的isa中寻找）
         2、当修改instance对象的属性的时候会调用Foundation的_NSSetXXXValueAndNotify函数,调用细节如下：
         willChangeValueForKey:
         父类原来的setter
         didChangeValueForKey:
         内部会触发监听器（Observe的监听方法）observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
     -------------------------------------------
     直接修改成员变量 会出发KVO吗？
        就算value没有改变也可以通过willChangeValueForKey: & didChangeValueForKey方法  ，直接修改成员变量 xxx -> ooo  不会出发KVO，因为KVO本质是在set方法中的一些处理，成员变量不会自动生成set方法
     -------------------------------------------
     使用KVC会触发KVO吗？
        
     -------------------------------------------
     */
    [self printAllMethodOfClass:object_getClass(self)];
}

-(void)printAllMethodOfClass:(Class)clazz{
    unsigned int count;
    Method *methodList = class_copyMethodList(clazz, &count);
    for (int i=0; i<count; i++) {
        Method method = methodList[i];
        NSString* methodName = NSStringFromSelector(method_getName(method));
        NSLog(@" %@ %@ \n",clazz,methodName);
    }
    NSLog(@"-------------------------------------------");
    free(methodList);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"pageDescription"]) {
        [self.textView utils_setText:self.pageDescription lineSpacing:5.f];
//        [NSThread sleepForTimeInterval:2]; //过两秒刷新页面
    }
}
- (IBAction)action1:(id)sender {
    self.pageDescription = nil;
    
    NSMutableString* m_str01 = [[NSMutableString alloc] initWithString:@"MMM"];
    NSMutableArray* m_array01 = [NSMutableArray arrayWithObjects:@"AAA",m_str01, nil];
    NSMutableArray* m_array02 = [m_array01 copy];
    NSMutableArray* m_array03 = [m_array01 mutableCopy];

    
    
    self.pageDescription = [NSString stringWithFormat:@"[m_array01 class] is %@ \n;[m_array02 class] is %@ \n;[m_array03 class] is %@ \n",NSStringFromClass([m_array01 class]),NSStringFromClass([m_array02 class]),NSStringFromClass([m_array03 class])];
    
    self.pageDescription = nil;
    
    [m_str01 appendString:@"AppendString"];
    
    self.pageDescription = [NSString stringWithFormat:@"修改可变字符串：m_array01 = %@ \n m_array02 = %@ \n m_array03 = %@ \n m_str01 = %@",m_array01,m_array02,m_array03,m_str01];
    

    [m_array03 removeObjectAtIndex:1];
    self.pageDescription = [NSString stringWithFormat:@"修改m_array03后：m_array01 = %@ \n m_array02 = %@ \n m_array03 = %@ \n m_str01 = %@",m_array01,m_array02,m_array03,m_str01];
    
   // [NSThread sleepForTimeInterval:2]; //过两秒刷新页面
    //[m_array02 removeObjectAtIndex:1];//代码会报错，因为m_array02是个NSArray对象
//    NSLog(@"m_array01 = %@ \n m_array02 = %@ \n m_array03 = %@ \n m_str01 = %@",m_array01,m_array02,m_array03,m_str01);
    
    
}
- (IBAction)action2:(id)sender {
    self.pageDescription = nil;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 100, 100)];
    [view1 setBounds:CGRectMake(-20, -20, 100, 100)];
    [view1 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view1];
     
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    [view2 setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3]];
    [view1 addSubview:view2];
    
    self.pageDescription = [NSString stringWithFormat:@"frame of view1:%@,bounds of view1:%@ \n frame of view1:%@,bounds of view1:%@ \n对bounds的x，y进行人为修改，并不会改变本视图的位置，却会改变其子视图的位置（即bounds决定的是子视图的原点）。demo中，view1的bounds x，y值设定为-20，-20，即红色视图的左上角坐标为（-20，-20），因此，对于灰色方块而言，其坐标原点参照父视图的坐标系，因此它的（0，0）点就下移了。",NSStringFromCGRect(view1.frame),NSStringFromCGRect(view1.bounds),NSStringFromCGRect(view2.frame),NSStringFromCGRect(view2.bounds)];
}
- (IBAction)action3:(id)sender {
    self.pageDescription = nil;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 100, 100)];
    [view1 setBounds:CGRectMake(-20, -20, 100, 100)];
    [view1 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view1];
     
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    [view2 setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3]];
    [view1 addSubview:view2];
    
    view1.center = CGPointMake(100, 300); // 改变center不会改变bounds只会改变frame
    
    self.pageDescription = [NSString stringWithFormat:@"frame of view1:%@,bounds of view1:%@ \n frame of view1:%@,bounds of view1:%@ \n",NSStringFromCGRect(view1.frame),NSStringFromCGRect(view1.bounds),NSStringFromCGRect(view2.frame),NSStringFromCGRect(view2.bounds)];
    
    /**
     * LLDB 调试中p打印出对应的值  po 调用对象对应的description 或 core foundation 的 CFShow  或 同 p
     (lldb) p view1
     (UIView *) $4 = 0x00007ff8c2008b50
     (lldb) po view1
     <UIView: 0x7ff8c2008b50; frame = (50 250; 100 100); layer = <CALayer: 0x6000016e09e0>>
     */
}
- (IBAction)action4:(id)sender {
    self.pageDescription = nil;
    /*
     -------------------------------------------
     使用KVC会触发KVO吗？
        会的
        KVC 会根据path中的参数去调用其对应的set方法：这里有一个细节 它首先需要判断accessInstanceVariablesDirectly返回值 如果为YES它就会直接去访问成员变量 _key _isKey key isKey这种变体的顺序去查找
     如果key没有对应的成员变量或者值则抛出异常
     -------------------------------------------
     */
    [self setValue:environmentName forKey:@"pageDescription"];
    /*
     getKey key _key isKey
     */
    
    self.pageDescription = [NSString stringWithFormat:@"[self setValue:environmentName forKey:]触发了KVO %@",[self valueForKey:@"name"]];
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"pageDescription" context:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
