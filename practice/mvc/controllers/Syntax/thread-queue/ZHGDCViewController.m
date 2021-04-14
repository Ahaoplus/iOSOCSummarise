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
//    [self threadAndRunloop];
//    [self testMainqueue];
//    [self barrier];
//    [self testSerialSync];
    //模拟异步耗时操作
//    [self testSerialAsync];
    
    [self lockUpQueue];//锁死
//    [self testGlobalQueue];
//    [self groupNotify];
    //并发队列中执行异步任务
//    [self testConcurrentAsync];
    // Do any additional setup after loading the view from its nib.
    [self initKnowladge];
    [self semaphoreTest];
}
-(void)semaphoreTest{
    dispatch_group_t group = dispatch_group_create();
    //方法接收一个long类型的参数, 返回一个dispatch_semaphore_t类型的信号量，值为传入的参数
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    for (int i = 0; i < 100; i++) {
        //接收一个信号和时间值，若信号的信号量为0，则会阻塞当前线程，直到信号量大于0或者经过输入的时间值；
        //若信号量大于0，则会使信号量减1并返回，程序继续住下执行
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(i<10? i:i/10);
            //当有线程之行结束之后会发送一个信号，使信号量加1然后就又可以执行了
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    //线程同步：加锁信号量初始值为1，wait减一，阻塞其他进程的执行，下面执行完了之后发信号才能解锁
    dispatch_queue_t queue2 = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore2 = dispatch_semaphore_create(1);
            
    for (int i = 0; i < 100; i++) {
         dispatch_async(queue2, ^{
              // 相当于加锁
              dispatch_semaphore_wait(semaphore2, DISPATCH_TIME_FOREVER);
             NSLog(@"i = %d semaphore = %@", i, semaphore2);
              // 相当于解锁
              dispatch_semaphore_signal(semaphore2);
          });
    }
    
}
-(void)initKnowladge{
    self.knowledgePoints =@"GCD(Grand Central Dispatch)\n\
    \n\苹果已经不推荐使用 NSThread 来进行并发编程，而是推荐使用 GCD 和 NSOperation，\n\
    \n\通常情况下，对于串行队列，我们应该自己创建，对于并行队列，就直接使用系统提供的 Default 优先级的 queue。\n\
    \n\在任务 block 中创建了大量对象，可以考虑在 block 中添加 autorelease pool。尽管每个 queue 自身都会有 autorelease pool 来管理内存，但是 pool 进行 drain 的具体时间是没办法确定的。如果应用对于内存占用比较敏感，可以自己创建 autorelease pool 来进行内存管理。\n\
    \n\\n\
    \n\\n\
    注意，串行队列中加入同步任务会阻塞下一个任务加入到队列中，只有当前任务执行完成才会再做下一个任务，也就是说它忙完一件事才会去想另一件事，\n\不会先生成一个待办列表才一个接一个的做，而是做一件事情，然后写到日记里，然后再做下一件，最后再写下来\n\
    也即是说我加入一个同步任务，必须要做完才能往我的队列中加入下一个任务\n\串行队列中执行的无论是同步还是异步的任务，这个任务中再在队列中追加同步任务就会造成锁死，异常代码已注释";
}
-(void)test01{
    NSLog(@"并发队列-异步任务------1-----");
}
-(void)test02{
    NSLog(@"并发队列-异步任务------2-------");
}
-(void)test03{
    NSLog(@"并发队列-异步任务------3------");
}
-(void)test04{
    NSLog(@"并发队列-异步任务------4------");
}
/**
 2020-11-15 20:43:01.716829+0800 practice[2723:31093] 并发队列-异步任务------1-----
 2020-11-15 20:43:01.716884+0800 practice[2723:31099] 并发队列-异步任务------2-------
 2020-11-15 20:43:01.716977+0800 practice[2723:31192] 并发队列-异步任务------4------
 注意： 3任务没打印出来，跟Runloop有关，没有启动
 */
-(void)threadAndRunloop{
    dispatch_queue_t queue = dispatch_queue_create("bing fa queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self test01];
    });
    dispatch_async(queue, ^{
        [self performSelector:@selector(test02) withObject:nil];
    });
    dispatch_async(queue, ^{
        [self performSelector:@selector(test03) withObject:nil afterDelay:.0];
    });
    dispatch_async(queue, ^{
        [self test04];
    });
}
/**
 * 串行队列 同步执行
 * 对于串行队列，GCD 默认提供了：『主队列（Main Dispatch Queue）』。
 *  1、所有放在主队列中的任务，都会放到主线程中执行。
 *  2、可使用 dispatch_get_main_queue() 方法获得主队列。
 *
 *  注意，串行队列中加入同步任务会阻塞下一个任务加入到队列中，只有当前任务执行完成才会再做下一个任务，也就是说它忙完一件事才会去想另一件事，
 *  不会先生成一个待办列表才一个接一个的做，而是做一件事情，然后写到日记里，然后再做下一件，最后再写下来
 *  也即是说我加入一个同步任务，必须要做完才能往我的队列中加入下一个任务
 *
 */
-(void)testSerialSync {
    // 串行队列的创建方法
    dispatch_queue_t queueSerial = dispatch_queue_create("test.sync.queue", DISPATCH_QUEUE_SERIAL);
    // 同步执行任务创建方法
    NSLog(@"--------------------------串行队列开始加入同步任务001---------------------------------");
    dispatch_sync(queueSerial, ^{
        // 这里放同步执行任务代码
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"********1、串行队列 同步执行---要把这个任务做完才能处理下一个任务%@********",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"--------------------------串行队列开始加入异步任务000我加入队列的操作被上一个任务的执行给阻塞了但是我不会阻塞我的下一个---------------------------------");
    dispatch_async(queueSerial, ^{  // 同步执行 + 当前串行队列
        // 追加任务 1
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"********2、串行队列开始加入异步任务000%@********",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"--------------------------串行队列开始加入同步任务002我加入队列的操作没有被上一个任务的执行给阻塞---------------------------------");
    dispatch_sync(queueSerial, ^{  // 同步执行 + 当前串行队列
        // 追加任务 1
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"********3、串行队列中加入同步执行任务---会阻塞主线程导致点击无效果等一会儿才能有响应%@********",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"--------------------------串行队列开始加入同步任务003我加入队列也被上一个任务的执行给阻塞了---------------------------------");
    dispatch_sync(queueSerial, ^{  // 同步执行 + 当前串行队列
        // 追加任务 1
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"********4、串行队列中加入同步执行任务---会阻塞主线程导致点击无效果等一会儿才能有响应%@********",[NSThread currentThread]);      // 打印当前线程
    });
    
    
}

/**
 串行队列 异步任务，
 不会在主线程中执行，而是开新的线程来执行所有异步任务，
 你把一个个的机器排成一排放在那里这是一件事儿
 你把每个机器的开关打开然后他运行，这是另一回事儿，模块的代码全部执行完了之后才执行下一个的，这里面可以再包含一步任务
 比喻：把异步任务加入到串行队列中就像是你写了一个待办列表，然后你必须自上而下一个接一个的打勾，这个打勾就是你执行这个任务里的代码，当然这个代码中也能有异步操作，他不会阻塞你执行下面的代码，但你只需要执行它就可以，你执行完了就倒下一个任务
 总之，我把所有的异步任务一个接一个的加入到队列中这是不会阻塞的，但是每个异步任务是否开始执行依仗着队列中上一个任务是否执行完
 */
-(void)testSerialAsync {
    // 串行队列的创建方法
    dispatch_queue_t queueSerial = dispatch_queue_create("test.ahao.queue", DISPATCH_QUEUE_SERIAL);
    // 异步执行任务创建方法
    NSLog(@"--------------------------串行队列开始加入异步任务001---------------------------------");
    dispatch_async(queueSerial, ^{
        // 这里放异步执行任务代码
        NSLog(@"1、串行队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"1、串行队列 异步执行---结束%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"--------------------------串行队列开始加入异步任务002---------------------------------");
    dispatch_async(queueSerial, ^{
        // 这里放异步执行任务代码
        NSLog(@"2、串行队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"2、串行队列 异步执行---结束%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"--------------------------串行队列开始加入异步任务003---------------------------------");
    dispatch_async(queueSerial, ^{
        // 这里放异步执行任务代码
        NSLog(@"3、串行队列 异步执行---开始%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"3、串行队列 异步执行---结束%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    
    /**
     串行队列中执行异步任务，异步任务中执行的时候又把一个异步任务加入到了串行队列
     */
    NSLog(@"--------------------------串行队列开始加入异步任务004---------------------------------");
    dispatch_async(queueSerial, ^{    // 异步执行 + 串行队列
        //[NSThread sleepForTimeInterval:5];
        NSLog(@"5、串行队列 异步执行---开始%@",[NSThread currentThread]);      // 打印当前线程
        NSLog(@"--------------------------串行队列开始加入异步任务006---------------------------------");
        dispatch_async(queueSerial, ^{  // 同步执行 + 当前串行队列
            // 追加任务 1
            NSLog(@"7、串行队列中加入异步执行任务，异步任务中又向串行队列中加了一个异步任务，当然它被追加到了最后了---start%@",[NSThread currentThread]);      // 打印当前线程
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"7、串行队列中加入异步执行任务，异步任务中又向串行队列中加了一个异步任务，当然它被追加到了最后了---end%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"5、串行队列 异步执行---开始%@",[NSThread currentThread]);
    });
    NSLog(@"--------------------------串行队列开始加入异步任务005---------------------------------");
    dispatch_async(queueSerial, ^{    // 异步执行 + 串行队列
        //
        NSLog(@"6、串行队列 异步执行---开始%@",[NSThread currentThread]);       // 打印当前线程
//        [NSThread sleepForTimeInterval:1];
        NSLog(@"6、串行队列 异步执行---开始%@",[NSThread currentThread]);
    });
}
/*
 串行队列中执行的无论是同步还是异步的任务，这个任务中再在队列中追加同步任务就会造成锁死，异常代码已注释
 */
-(void)lockUpQueue{
    // 串行队列的创建方法
    //1243
    dispatch_queue_t queueSerial = dispatch_queue_create("test.lock.queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"================1=================");
    dispatch_sync(queueSerial,^{
        NSLog(@"================2=================");
        dispatch_async(queueSerial,^{
            NSLog(@"================3=================");
        });
        NSLog(@"================4=================");
    });
    NSLog(@"================5=================");
    /*
     NSLog(@"1、*****************死锁状况1：串行队列中加入 同步任务，同步任务执行的时候又把一个新的同步任务加入到串行队列中************************");
    dispatch_sync(queueSerial, ^{    // 异步执行 + 串行队列
        
        NSLog(@"2、并行队列中加入异步执行任务，任务中又在 串行队列中加入 同步任务---%@",[NSThread currentThread]);
        //报错 Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
        dispatch_sync(queueSerial, ^{  // 同步执行 + 当前串行队列
            // 追加任务 1
            NSLog(@"3、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"555555555操作结束了我");
    });
     */
    
    //死锁状况2
    /*
    NSLog(@"1、*****************死锁状况2：串行队列中加入 串行队列中执行异步任务，异步任务中执行的时候又把同步任务追加到队列中，这时候这个同步任务是追加在了队列末尾，但是这个异步的完成依赖这个同步任务，这个同步任务又在等异步任务结束************************");
    dispatch_async(queueSerial, ^{    // 异步执行 + 串行队列
        NSLog(@"2、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
        dispatch_sync(queueSerial, ^{  // 同步执行 + 当前串行队列
            // 追加任务 3
            NSLog(@"3、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
    //Thread 7: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
    NSLog(@"4、串行队列中加入异步执行任务，任务中又有同步 执行串行队列 同步执行---%@",[NSThread currentThread]);
     */
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
    const int fullTimeSalary = 1000;
    const int partTimeSalary = 501;
    __block int balance = 0;
    //两个for循环会出现竞争关系
    dispatch_async(queue, ^{
        for (int i=0; i<10; i++) {
            balance += fullTimeSalary;
            NSLog(@"AAAA---balance : %d",balance);
        }
    });
    //
    for (int i=0; i<10; i++) {
        balance += partTimeSalary;
        NSLog(@"BBBBB-balance : %d",balance);
    }
    
    
    
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
        for(int i = 0; i<10;i++){
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        for(int i = 0; i<10;i++){
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务 1、任务 2 都执行完毕后，回到主线程执行下边任务
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        for(int i = 0; i<10;i++){
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
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
