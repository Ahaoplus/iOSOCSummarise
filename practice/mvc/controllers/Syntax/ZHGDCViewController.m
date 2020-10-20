//
//  ZHGDCViewController.m
//  practice
//
//  Created by 张浩 on 2020/10/20.
//

#import "ZHGDCViewController.h"

@interface ZHGDCViewController ()

@end

@implementation ZHGDCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testMainqueue];
    [self barrier];
//    [self testSerialSync];
//    [self testSerialAsync];
    
    //并发队列中执行异步任务
//    [self testConcurrentAsync];
    // Do any additional setup after loading the view from its nib.
}

/**
 * 串行队列 同步执行
 * 对于串行队列，GCD 默认提供了：『主队列（Main Dispatch Queue）』。
 *  1、所有放在主队列中的任务，都会放到主线程中执行。
 *  2、可使用 dispatch_get_main_queue() 方法获得主队列。
 */
-(void)testSerialSync {
    // 串行队列的创建方法
    dispatch_queue_t queueSerial = dispatch_queue_create("test.ahao.queue", DISPATCH_QUEUE_SERIAL);
    // 同步执行任务创建方法
    dispatch_sync(queueSerial, ^{
        // 这里放同步执行任务代码
        [NSThread sleepForTimeInterval:5];              // 模拟耗时操作
        NSLog(@"********1、串行队列 同步执行---会阻塞主线程导致点击无效果等一会儿才能有响应%@********",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queueSerial, ^{  // 同步执行 + 当前串行队列
        // 追加任务 1
        [NSThread sleepForTimeInterval:5];              // 模拟耗时操作
        NSLog(@"********2、串行队列中加入同步执行任务---会阻塞主线程导致点击无效果等一会儿才能有响应%@********",[NSThread currentThread]);      // 打印当前线程
    });
    
    
}

//串行队列 异步任务，不会在主线程中执行，而是开新的线程来执行异步任务，但每个任务虽然是异步的但前面的会阻塞后面的
-(void)testSerialAsync {
    // 串行队列的创建方法
    dispatch_queue_t queueSerial = dispatch_queue_create("test.ahao.queue", DISPATCH_QUEUE_SERIAL);
    // 异步执行任务创建方法
    dispatch_async(queueSerial, ^{
        // 这里放异步执行任务代码
        NSLog(@"1、串行队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:5];              // 模拟耗时操作
        NSLog(@"1、串行队列 异步执行---结束%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queueSerial, ^{
        // 这里放异步执行任务代码
        NSLog(@"2、串行队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:4];              // 模拟耗时操作
        NSLog(@"2、串行队列 异步执行---结束%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queueSerial, ^{
        // 这里放异步执行任务代码
        NSLog(@"3、串行队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:8];              // 模拟耗时操作
        NSLog(@"3、串行队列 异步执行---结束%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    //死锁状况1：串行队列中加入 同步任务，同步任务执行的时候又把一个新的同步任务加入到串行队列中
//    dispatch_sync(queueSerial, ^{    // 异步执行 + 串行队列
//        [NSThread sleepForTimeInterval:5];
//        NSLog(@"4、并行队列中加入异步执行任务，任务中又在 串行队列中加入 同步任务---%@",[NSThread currentThread]);      // 打印当前线程
//        dispatch_sync(queueSerial, ^{  // 同步执行 + 当前串行队列
//            // 追加任务 1
//            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
//            NSLog(@"4、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
//        });
//    });
    
    /**
     串行队列中执行异步任务，异步任务中执行的时候又把一个异步任务加入到了串行队列
     
     */
    dispatch_async(queueSerial, ^{    // 异步执行 + 串行队列
        //[NSThread sleepForTimeInterval:5];
        NSLog(@"5、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
        dispatch_async(queueSerial, ^{  // 同步执行 + 当前串行队列
            // 追加任务 1
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"5、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
    //死锁状况2
    /**
     串行队列中执行异步任务，异步任务中执行的时候又把一
     
     */
//    dispatch_async(queueSerial, ^{    // 异步执行 + 串行队列
//        //[NSThread sleepForTimeInterval:5];
//        NSLog(@"6、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
//        dispatch_sync(queueSerial, ^{  // 同步执行 + 当前串行队列
//            // 追加任务 1
//            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
//            NSLog(@"6、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
//        });
//    });
    
    
    dispatch_async(queueSerial, ^{    // 异步执行 + 串行队列
        [NSThread sleepForTimeInterval:5];
        NSLog(@"7、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
    });
}

/**
 * 主队列：特殊串行队列 同步执行
 * 对于串行队列，GCD 默认提供了：『主队列（Main Dispatch Queue）』。
 *  1、所有放在主队列中的任务，都会放到主线程中执行。
 *  2、可使用 dispatch_get_main_queue() 方法获得主队列。
 */
-(void)testMainqueue{
    // 主队列的获取方法
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t queueSerial = dispatch_queue_create("test.ahao.queue", DISPATCH_QUEUE_SERIAL);
    //任务1排在最前面先执行，任务2中向主队列追加了一个任务4，主队列是串行队列，所以任务3这是排在任务3后面，这时候任务4会等待任务3的完成，而任务3又等待任务2的完成，任务2又是同步任务，让要等里面的代码完成了他才算完成，即要等任务4完成
    //此种情况和testSerialAsync  同步任务加入到串行队列然后，任务中又将
    NSLog(@"1"); // 任务1
    dispatch_sync(queueSerial, ^{
        NSLog(@"queueSerial-----2");//任务4
        NSLog(@"7、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
    });// 任务2
    dispatch_sync(mainQueue, ^{
        
        NSLog(@"2");//任务4
        NSLog(@"7、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
    });// 任务2
    NSLog(@"3"); // 任务3
}
//并发队列 同步执行
-(void)testConcurrentSync{
    // 并发队列的创建方法
    dispatch_queue_t queueConcurent = dispatch_queue_create("test.ahao.queue", DISPATCH_QUEUE_CONCURRENT);
}


//并发队列 异步执行
-(void)testConcurrentAsync{
    // 并发队列的创建方法
    dispatch_queue_t queueConcurent = dispatch_queue_create("test.ahao.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queueConcurent, ^{
        // 这里放异步执行任务代码
        NSLog(@"1、并发队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1、并发队列 异步执行---结束？假的%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queueConcurent, ^{
        // 这里放异步执行任务代码
        NSLog(@"2、并发队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2、并发队列 异步执行---结束？假的%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queueConcurent, ^{
        // 这里放异步执行任务代码
        NSLog(@"3、并发队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3、并发队列 异步执行---结束？假的%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queueConcurent, ^{
        // 这里放异步执行任务代码
        NSLog(@"4、并发队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"4、并发队列 异步执行---结束？假的%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queueConcurent, ^{
        // 这里放异步执行任务代码
        NSLog(@"5、并发队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"5、并发队列 异步执行---结束？假的%@",[NSThread currentThread]);      // 打印当前线程
    });
}


/**
 * 并发队列默认队列：全局并发队列
 *
 */
-(void)testGlobalQueue{
    // 全局并发队列的获取方法
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}


/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 4
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
    });
}

/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务 1、任务 2 都执行完毕后，回到主线程执行下边任务
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        NSLog(@"group---end");
    });
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
