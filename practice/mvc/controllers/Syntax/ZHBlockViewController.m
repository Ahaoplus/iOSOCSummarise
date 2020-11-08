//
//  ZHBlockViewController.m
//  practice
//
//  Created by 张浩 on 2020/10/26.
//

#import "ZHBlockViewController.h"
#import "BaseModel.h"
@interface ZHBlockViewController ()

@end

@implementation ZHBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test01];
    [self test02];
    [self test03];
    [self test04];
    [self test05];
    [self testSelf01];
    [self testBlockTypes];
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
    
    NSLog(@"%@",[block class]);
    NSLog(@"%@",[block1 class]);
    NSLog(@"%@",[block2 class]);
    NSLog(@"%@",[block3 class]);
    
    
    NSLog(@"%@",[[^{
        NSLog(@"block2");
    } copy] class]);
    
    NSLog(@"%@",[^{
        
    } class]);
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
