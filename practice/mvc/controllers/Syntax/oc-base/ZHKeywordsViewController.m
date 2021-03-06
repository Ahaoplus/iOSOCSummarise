//
//  ZHKeywordsViewController.m
//  practice
//
//  Created by 张浩 on 2020/10/7.
//

#import "ZHKeywordsViewController.h"
#import "ZHKeywordsModel.h"
#import "TestModel.h"
#import "Test2Model.h"
#import "ZHUIMaker.h"

static int clickCount = 1;
@interface ZHKeywordsViewController ()
{
    ZHKeywordsModel* strModel;
    NSMutableString* mulStr; // 使用可变字符串可以看出strong和copy的不同
    
    UILabel* labelCopy;
    UILabel* labelStrong;
    UILabel* labelAssign;
    UILabel* labelWeak;
}
@property(atomic,assign)NSInteger count;//atomic只能保证getter和setter内部操作是线程安全的，它并不能保证属性使用过程中是线程安全的，
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,strong)CADisplayLink* displayLink;
@end

@implementation ZHKeywordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id array1 = [[NSArray alloc]init];//不可变
    id m_array1 = [[NSMutableArray alloc]init];//可变
    
    id array2 = [array1 copy];//不可变，浅拷贝
    id array3 = [array1 mutableCopy];//可变，深拷贝
    
    id m_array2 = [m_array1 copy];//不可变，深拷贝
    id m_array3 = [m_array1 mutableCopy];//可变，深拷贝
    
    //还有局部深拷贝，这个数组深拷贝了，但是数组中的变量没有深拷贝，可以在调用muticopy的时候 copyItems
    
    NSLog(@"%@;%@;%@;%@;%@;%@",array1,m_array1,array2,m_array2,array3,m_array3);
    self.title = @"关键字总结";
    NSString* load = @"load方法在main函数之前执行，父类-子类-分类的方法执行 +[BaseModel load]\n+[Test2Model load]\n+[ZHKeywordsModel load]\n+[BaseModel(Practise) load]\n+[BaseModel(Test) load]\n+[Test2Model(Test2) load]\n+[ZHKeywordsModel(Test) load]\n+[Test2Model(Test) load]\n";
    NSString* lazy = @"\n1、+[BaseModel(Test) initialize]\n2、 +[ZHKeywordsModel(Test) initialize]\n3、+[TestModel initialize]";
    self.knowledgePoints = [NSString stringWithFormat:@"%@\n%@",load,lazy];
    [self atomicTest];
    mulStr = [NSMutableString stringWithString:@"我是一个可变字符串："];
    strModel = [ZHKeywordsModel new];
    /*
     (lldb) p mulStr
     (__NSCFString *) $1 = 0x00006000036e4810 @"我是一个可变字符串："
     (lldb) p strModel.strAssgin
     (__NSCFString *) $2 = 0x00006000036e4810 @"我是一个可变字符串："
     (lldb) p strModel.strCopy
     (__NSCFString *) $3 = 0x00006000036e2cd0 @"我是一个可变字符串："
     (lldb) p strModel.strStrong
     (__NSCFString *) $4 = 0x00006000036e4810 @"我是一个可变字符串："
     (lldb) p strModel.strWeak
     (__NSCFString *) $5 = 0x00006000036e4810 @"我是一个可变字符串："
     */
    strModel.strAssgin = mulStr;
    strModel.strCopy = mulStr;
    strModel.strStrong = mulStr;
    strModel.strWeak = mulStr;
    
    id cls  = [ZHKeywordsModel class];
    void *obj = &cls;
    [(__bridge id)obj print];
    
    labelCopy = [ZHUIMaker ZHCustomLabelWithY:100];
    [self.view addSubview:labelCopy];
    
    labelStrong = [ZHUIMaker ZHCustomLabelWithY:140];
    [self.view addSubview:labelStrong];
    
    labelAssign = [ZHUIMaker ZHCustomLabelWithY:180];
    [self.view addSubview:labelAssign];
    
    labelWeak = [ZHUIMaker ZHCustomLabelWithY:220];
    [self.view addSubview:labelWeak];
    
    labelCopy.text = strModel.strCopy;
    labelStrong.text = strModel.strStrong;
    labelAssign.text = strModel.strAssgin;
    labelWeak.text = strModel.strWeak;
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(10, 400, 300, 40)];
    [button addTarget:self action:@selector(changeMulString) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"点击三下出现野指针奔溃" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor systemBlueColor]];
    [self.view addSubview:button];
    
    //调用这两个看看initialize方法：如果有就调用父类的然后是自己的，如果没有则只调用父类的
    TestModel* model1 = [TestModel new];
    model1.exerciseName = @"艺术体操";
    NSLog(@"%@",model1.exerciseName);
    [Test2Model new];
    
    [self testCopy];
    
    id baseModel = [BaseModel new];
    [baseModel testCopy];
}
-(void)display{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction)];
}
-(void)displayAction{
    NSLog(@"%s",__func__);
}
-(void)atomicTest{
    self.count = 0;
    self.number = 0;
    dispatch_queue_t concurrentQueue = dispatch_queue_create("aaa", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatch_group = dispatch_group_create();
    
    dispatch_group_async(dispatch_group, concurrentQueue, ^{
        for (int i=0; i<100; i++) {//+100
            self.count++;
        }
        NSLog(@"1、self.count is %ld ",(long)self.count);
    });
    dispatch_group_async(dispatch_group, concurrentQueue, ^{
        for (int i=0; i<100; i++) {//+100
            self.number++;
        }
        NSLog(@"1、self.number is %ld",(long)self.number);
    });
    dispatch_group_async(dispatch_group,concurrentQueue, ^{
        for (int i=0; i<100; i++) {//-100
            self.count--;
        }
        NSLog(@"2、self.count is %ld ;self.number is %ld",(long)self.count,(long)self.number);
    });
    dispatch_group_async(dispatch_group,concurrentQueue, ^{
        
        for (int i=0; i<100; i++) {//-100
            self.number--;
        }
        NSLog(@"2、self.count is %ld ;self.number is %ld",(long)self.count,(long)self.number);
    });
    
    dispatch_group_async(dispatch_group,concurrentQueue, ^{
        for (int i=0; i<1000; i++) {//-100
            self.count--;
            
        }
        NSLog(@"3、self.count is %ld ;self.number is %ld",(long)self.count,(long)self.number);
    });
    dispatch_group_async(dispatch_group,concurrentQueue, ^{
        for (int i=0; i<1000; i++) {//-100
            self.number--;
        }
        
        NSLog(@"3、self.count is %ld ;self.number is %ld",(long)self.count,(long)self.number);
    });
    dispatch_group_async(dispatch_group,concurrentQueue, ^{
        
        for (int i=0; i<1000; i++) {//+1000
            self.number++;
        }
        NSLog(@"4、self.count is %ld ;self.number is %ld",(long)self.count,(long)self.number);
    });
    dispatch_group_async(dispatch_group,concurrentQueue, ^{
        for (int i=0; i<1000; i++) {//+1000
            self.count++;
        }
        
        NSLog(@"4、self.count is %ld ;self.number is %ld",(long)self.count,(long)self.number);
    });
    dispatch_group_notify(dispatch_group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"the end result is self.count is %ld ;self.number is %ld",(long)self.count,(long)self.number);
    });
    dispatch_group_notify(dispatch_group,dispatch_get_main_queue(), ^{
        self->labelStrong.text = [NSString stringWithFormat:@"self.count(atomic) is %ld ;self.number is %ld",(long)self.count,(long)self.number];
        self->labelCopy.text = [NSString stringWithFormat:@"the right result is self.count = 0 ;self.number = 0"];
    });
}
-(void)changeMulString{
    [mulStr appendString:[NSString stringWithFormat:@"-%d-",clickCount]];
    
    clickCount++;
    if (clickCount>3) {
        mulStr = nil;
        strModel.strWeak = nil;
    }
    if (clickCount > 4) {
        mulStr = nil;//引用计数-1
        strModel.strStrong = nil;//引用计数-1变为0,
        //再访问strModel.strAssgin报错Thread 1: EXC_BAD_ACCESS (code=1, address=0x1ce29cd8a9c0)野指针，所以assign最好不要用来修饰类
    }
    //NSLog(@"strModel.strCopy:%@;strModel.strStrong:%@;strModel.strAssgin:%@",strModel.strCopy,strModel.strStrong,strModel.strAssgin);
    //NSLog(@"strModel.strWeak:%@",strModel.strWeak);//weak\strong\copy 都是类安全的
    
    labelCopy.text = strModel.strCopy;
    labelStrong.text = strModel.strStrong;
    labelAssign.text = strModel.strAssgin;
    labelWeak.text = strModel.strWeak;
}
-(void)testCopy{
    NSArray* array1 = @[@1,@2];
    id mulObj = [array1 mutableCopy];//只是深拷贝，但是并不会产生multi对象
    if ([mulObj isMemberOfClass:[NSMutableArray class]]) {
        [mulObj addObject:@3];
    }
    NSLog(@"mulObj:%p-%@，array1：%p-%@,&mulObj:%p，&array1：%p",mulObj,mulObj,array1,array1,&mulObj,array1);
}
-(void)treeDateTreePrint:(NSArray*)dataArray{
    NSArray* treeData = [self treeData];
    for (NSDictionary* node in treeData) {
        NSLog(@"node title is %@",node[@"title"]);
        if ([node[@"children"] isKindOfClass:[NSArray class]]) {
            
        }
    }
}

-(NSArray*)treeData{
    return  @[
    @{
        @"title":@"A",
        @"children":@[
                @{@"title":@"A-A",
                  @"children":@[
                          @{@"title":@"A-A-A",@"children":@[]},
                          @{@"title":@"A-A-B",@"children":@[]},
                          @{@"title":@"A-A-C",@"children":@[]},
                          @{@"title":@"A-A-D",@"children":@[]},
                  ]},
                @{@"title":@"A-B",
                  @"children":@[
                          @{@"title":@"A-B-A",@"children":@[]},
                          @{@"title":@"A-B-B",@"children":@[]},
                          @{@"title":@"A-B-C",@"children":@[]},
                          @{@"title":@"A-B-D",@"children":@[]},
                  ]},
                @{@"title":@"A-C",
                  @"children":@[
                          @{@"title":@"A-C-A",@"children":@[]},
                          @{@"title":@"A-C-B",@"children":@[]},
                          @{@"title":@"A-C-C",@"children":@[]},
                          @{@"title":@"A-C-D",@"children":@[]},
                  ]}
        ]
    },
    @{
        @"title":@"B",
        @"children":@[
                @{@"title":@"B-A",
                  @"children":@[
                          @{@"title":@"B-A-A",@"children":@[]},
                          @{@"title":@"B-A-B",@"children":@[]},
                          @{@"title":@"B-A-C",@"children":@[]},
                          @{@"title":@"B-A-D",@"children":@[]},
                  ]},
                @{@"title":@"B-B",
                  @"children":@[
                          @{@"title":@"B-B-A",@"children":@[]},
                          @{@"title":@"B-B-B",@"children":@[]},
                          @{@"title":@"B-B-C",@"children":@[]},
                          @{@"title":@"B-B-D",@"children":@[]},
                  ]},
                @{@"title":@"B-C",
                  @"children":@[
                          @{@"title":@"B-C-A",@"children":@[]},
                          @{@"title":@"B-C-B",@"children":@[]},
                          @{@"title":@"B-C-C",@"children":@[]},
                          @{@"title":@"B-C-D",@"children":@[]},
                  ]}
        ]
    },
    @{
        @"title":@"C",
        @"children":@[
                @{@"title":@"C-A",
                  @"children":@[
                          @{@"title":@"C-A-A",@"children":@[]},
                          @{@"title":@"C-A-B",@"children":@[]},
                          @{@"title":@"C-A-C",@"children":@[]},
                          @{@"title":@"C-A-D",@"children":@[]},
                  ]},
                @{@"title":@"C-B",
                  @"children":@[
                          @{@"title":@"C-B-A",@"children":@[]},
                          @{@"title":@"C-B-B",@"children":@[]},
                          @{@"title":@"C-B-C",@"children":@[]},
                          @{@"title":@"C-B-D",@"children":@[]},
                  ]},
                @{@"title":@"C-C",
                  @"children":@[
                          @{@"title":@"C-C-A",@"children":@[]},
                          @{@"title":@"C-C-B",@"children":@[]},
                          @{@"title":@"C-C-C",@"children":@[]},
                          @{@"title":@"C-C-D",@"children":@[]},
                  ]}
        ]
    },
    @{
        @"title":@"D",
        @"children":@[
                @{@"title":@"D-A",
                  @"children":@[
                          @{@"title":@"D-A-A",@"children":@[@{@"title":@"D-A-A-A",@"children":@[]},@{@"title":@"D-A-A-B",@"children":@[]},]},
                          @{@"title":@"D-A-B",@"children":@[]},
                          @{@"title":@"D-A-C",@"children":@[]},
                          @{@"title":@"D-A-D",@"children":@[]},
                  ]},
                @{@"title":@"D-B",
                  @"children":@[
                          @{@"title":@"D-B-A",@"children":@[]},
                          @{@"title":@"D-B-B",@"children":@[]},
                          @{@"title":@"D-B-C",@"children":@[]},
                          @{@"title":@"D-B-D",@"children":@[]},
                  ]},
                @{@"title":@"D-C",
                  @"children":@[
                          @{@"title":@"D-C-A",@"children":@[]},
                          @{@"title":@"D-C-B",@"children":@[]},
                          @{@"title":@"D-C-C",@"children":@[]},
                          @{@"title":@"D-C-D",@"children":@[]},
                  ]},
                @{@"title":@"D-D",
                  @"children":@[
                          @{@"title":@"D-D-A",@"children":@[]},
                          @{@"title":@"D-D-B",@"children":@[]},
                          @{@"title":@"D-D-C",@"children":@[]},
                          @{@"title":@"D-D-D",@"children":@[]},
                  ]}
        ]
    }];
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
