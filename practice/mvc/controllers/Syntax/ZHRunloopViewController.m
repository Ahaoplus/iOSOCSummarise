//
//  ZHRunloopViewController.m
//  practice
//
//  Created by 张浩 on 2020/11/7.
//
/**
 NSTimer失效解决
 线程保活 控制线程的生命周期，AFNetworking就有使用，因为要在一个线程中做很多事情，不能老是销毁然后创建，很麻烦
 */
#import "ZHRunloopViewController.h"
#import "ZHThread.h"
@interface ZHRunloopViewController ()
@property(nonatomic,strong)ZHThread* zthread;
@property(nonatomic,assign,getter=isStoped)BOOL stop;
@end

@implementation ZHRunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stop = NO;
    // 这样开启一个线程会产生循环引用，这样初始化的话thread会对viewcontroller有强引用
    //self.zthread = [[ZHThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    __weak typeof(self) weakSelf = self;
    self.zthread = [[ZHThread alloc]initWithBlock:^{
        NSLog(@"runloop start %s",__func__);
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        //__strong typeof(self) strongSelf = weakSelf;  //会循环引用
        while (weakSelf && !weakSelf.isStoped) {
            NSLog(@"weakSelf is %@",weakSelf);//weakSelf is (null)
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"runloop end %s",__func__);
    }];
    [self.zthread start];
    
    /*
     // about timer
    NSTimer* timer = [NSTimer timerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"----------------------");
    }];
    //使用NSDefaultRunLoopMode 滑动scrollview的时候会被阻塞
    //[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];*/
}
//如果不调用stop的话runloop就不会停止，就没办法销毁
- (IBAction)stopRunloop:(id) button {
    [self performSelector:@selector(stopAction) onThread:self.zthread  withObject:nil waitUntilDone:YES];
}
-(void)dddStop{
    [self performSelector:@selector(stopAction) onThread:self.zthread  withObject:nil waitUntilDone:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //TODO 点一下再点一下就挂掉了
    [self performSelector:@selector(test) onThread:self.zthread withObject:nil waitUntilDone:YES];
    NSLog(@"%s",__func__);
}
-(void)test{
    //在这个线程执行事情，并且这个线程是保活的
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}

-(void)stopAction{
    self.stop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}
//很奇怪，直接在block中调用方法会导致强引用
-(void)run{
    //这个Runloop是和zthread对应的
    
    //[[NSRunLoop currentRunLoop] run];是无法停止的，他专门用来开启一个永不销毁的线程
//    [[NSRunLoop currentRunLoop] run];
    //这个只会run一次
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    while (!self.isStoped) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
    }
    NSLog(@"runloop end %s",__func__);
}
-(void)dealloc{
    NSLog(@"%s",__func__);
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
