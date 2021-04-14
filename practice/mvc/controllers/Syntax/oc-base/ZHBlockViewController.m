//
//  ZHBlockViewController.m
//  practice
//
//  Created by 张浩 on 2020/10/26.
//

#import "ZHBlockViewController.h"
#import "BaseModel.h"
#import "UIImageView+AFNetworking.h"
@interface ZHBlockViewController ()
{
    id blockTool;// 知识点
}
@end

@implementation ZHBlockViewController

- (void)viewDidLoad {
    self.title = @"Blocks";
    [super viewDidLoad];
    blockTool = [NSObject new];
    [self test01];
    [self test02];
    [self test03];
    [self test04];
    [self test05];
    [self testSelf01];
    [self testBlockTypes];
    [self keyWorksTest];
    self.knowledgePoints = @"1、block本质就是一个OC对象：它是封装了函数调用以及函数调用环境的OC对象\n，\
    NSObject ->NSBlock->(__NSGlobalBlock/__NSStackBlock/__NSMallocBlock)->(__NSGlobalBlock__/__NSStackBlock__/__NSMallocBlock__);\
    \n2、变量捕获：auto变量值传递，static变量指针传递，全局变量不会（不需要）被捕获\
    \n3、block根据存储位置的不同分为如下几种：\
    \n的对象类型__NSMallocBlock__引用了self变量\
    \n__NSMallocBlock__引用了外部变量age\n \
    __NSGlobalBlock__未引用任何外部变量\n \
    __NSGlobalBlock__引用了static变量\n \
    __weak在ARC下修饰了block变量：<__NSStackBlock__: 0x7ffee4b60ac0> \
    \n4、解决循环引用可以用__weak（自动nil）和__unsafe_unretained（指针不会变nil，不安全）关键字；还有就是__block也可以解决循环引用问题，三角形强引用，在block中置空，因为__block会给那个变量包一层struct\
    \n5、__block用来修饰局部变量，把值传递改成引用传递\
    \nblock中需要修改MutableArray是不需要加__block";
}

-(void)test01{
    NSLog(@"---------------------------------------------------------");
    int age = 10;//有默认的auto未显式写出 传一个引用地址
    void (^block)(void)=^{
        //方法：-[ZHBlockViewController test01]_block_invoke age is 10
        NSLog(@"方法：%s age is %d",__FUNCTION__,age);
    };
    age = 30;
    block();
    
}
-(void)test02{
    NSLog(@"---------------------------------------------------------");
    __block int age = 10;//相当于static 传一个引用地址
    void (^block)(void)=^{
        //方法：-[ZHBlockViewController test01]_block_invoke age is 30
        NSLog(@"方法：%s age is %d",__FUNCTION__,age);
    };
    age = 30;
    block();
}

-(void)test03{
    NSLog(@"---------------------------------------------------------");
    auto int age = 10; //值传递
    static int height = 10; //指针传递
    void (^block)(void)=^{
        //方法：-[ZHBlockViewController test01]_block_invoke age is 30
        NSLog(@"方法：%s age is %d height is %d",__FUNCTION__,age,height);
    };
    age = 30;
    height = 180;
    block();
}
/*
-[ZHBlockViewController test04] age is 10 &age is 0x7ffeedb8fb78
-[ZHBlockViewController test04]_block_invoke age is 10 &age is 0x6000021a7c58
-[ZHBlockViewController test04] age is 10 &age is 0x6000021a7c58
 age被包装到一个struct里面了
 */
-(void)test04{
    NSLog(@"---------------------------------------------------------");
    __block int age = 10; //值传递
    NSLog(@"方法：%s age is %d &age is %p",__FUNCTION__,age,&age);
    void (^block)(void)=^{
        //方法：-[ZHBlockViewController test01]_block_invoke age is 30
        NSLog(@"方法：%s age is %d &age is %p",__FUNCTION__,age,&age);
    };
//    age = 30;

    block();
    
    NSLog(@"方法：%s age is %d &age is %p",__FUNCTION__,age,&age);
}

-(void)test05{
    NSLog(@"---------------------------------------------------------");
    BaseModel *model = [[BaseModel alloc]init];
    __block __weak BaseModel *weakModel = model; //值传递
    NSLog(@"方法：%s model %p",__FUNCTION__,model);
    NSLog(@"方法：%s weakModel %p",__FUNCTION__,weakModel);
    void (^block)(void)=^{
        //方法：-[ZHBlockViewController test01]_block_invoke age is 30
        NSLog(@"方法：%s model is %p",__FUNCTION__,model);
        NSLog(@"方法：%s weakModel %p",__FUNCTION__,weakModel);
    };
//    age = 30;

    block();
    
    
}
-(void)test06{
    NSLog(@"---------------------------------------------------------");
    //在ARC下 使用__block  block会被拷贝到堆上，有一个结构体中包含一个model的强引用 ，MRC下不会是强引用他会提前释放不加block则是强引用retain了需要release两次
    __block  BaseModel *model = [[BaseModel alloc]init];
    void (^block)(void)=^{
        //方法：-[ZHBlockViewController test01]_block_invoke age is 30
        NSLog(@"方法：%s model is %p",__FUNCTION__,model);
    };

    block();
    
    
}
-(void)testSelf01{
    NSLog(@"---------------------------------------------------------");

    void (^block)(void)=^{
        //方法：-[ZHBlockViewController test01]_block_invoke age is 30
        NSLog(@"方法：%s ,self is %p ，self是局部变量",__FUNCTION__,self);
    };
    block();
}
/**
 * 应用程序的内存分配：
 * 程序区域 text区
 * 数据区域 data区   _NSConcreteGlobalBlock
 * 堆    _NSConcreteMallocBlock
 * 栈    _NSConcreteStackBlock
 */
-(void)testBlockTypes{
    NSLog(@"---------------------------------------------------------");
    int age = 10;
    void (^block)(void)=^{
        //方法：-[ZHBlockViewController test01]_block_invoke age is 30
        NSLog(@"方法：%s ,self is %p ，self是局部变量",__FUNCTION__,self);
    };
    
    void (^block1)(void)=^{
        //方法：-[ZHBlockViewController test01]_block_invoke age is 30
        NSLog(@"age is %d",age);
    };
    
    void (^block2)(void)=^{
        
        for (int i=0; i++; i<10) {
            i++;
        }
    };
    static int height = 100;
    void (^block3)(void)=^{
        //方法：-[ZHBlockViewController test01]_block_invoke age is 30
        NSLog(@"block3 %d",height);
    };
    
    block();
    
    NSLog(@"%@引用了self变量",[block class]);
    NSLog(@"%@引用了外部变量age",[block1 class]);
    NSLog(@"%@未引用任何外部变量",[block2 class]);
    NSLog(@"%@引用了static变量",[block3 class]);
    //ARC下默认都是__strong修饰符修饰的，堆栈如果引用了外部变量则会被自动放到堆空间
    int value = 10;
    __weak void(^blockA)() = ^{
    NSLog(@"value: %d",value);
    };
    //输出结果
    NSLog(@"__weak在ARC下修饰了block变量：%@",blockA);
    
    NSLog(@"%@",[[^{
        NSLog(@"block2");
    } copy] class]);
    
    NSLog(@"%@",[^{
        
    } class]);
}
/**
 * __block修饰局部object
 * __weak
 * __strong
 */
-(void)keyWorksTest{
    NSLog(@"-------------------------keyWorksTest--------------------------------");
    __block UIImage* image = nil;//在block中改变局部变量必须得加block，尤其是你修改对象的话不加直接编译不通过
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,100,200,200)];
    
    [self.view addSubview:imageView];
    
    __weak typeof(self) weakSelf = self;
    BaseModel* model = [BaseModel new];
    void (^block)(void)=^{
        image = [UIImage imageNamed:@"蜘蛛侠落地"];
        model.name = @"去你大爷的";
        //model = nil; 可以改变auto的属性值，但是不能改变指针本身
        __strong typeof(self) strongSelf = weakSelf;
        NSLog(@"方法：%s ,self is %p-%@ ，self是局部变量,strongSelf is %p-%@ ，self是局部变量,weakSelf is %p-%@ ，self是局部变量,blockTool is %@",__FUNCTION__,self,self,strongSelf,strongSelf,weakSelf,weakSelf,strongSelf->blockTool);
    };
    [imageView setImage:image];
    NSLog(@"model.name is %@",model.name);
    block();
    NSLog(@"model.name is %@",model.name);
    [imageView setImageWithURL:[NSURL URLWithString:@"http://172.16.17.48:8080/IMG_4577.JPG"]];
    
    [imageView removeFromSuperview];
    
}
-(void)dealloc{
    NSLog(@"方法：%s",__FUNCTION__);
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
