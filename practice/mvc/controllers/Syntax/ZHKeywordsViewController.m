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
@end

@implementation ZHKeywordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关键字总结";
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
