//
//  ZHOperationViewController.m
//  practice
//
//  Created by 张浩 on 2020/12/27.
//

#import "ZHOperationViewController.h"
#import "ZHCustomOperation.h"
#import "ZHOperationQueue.h"
@interface ZHOperationViewController ()

@end

@implementation ZHOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self onlyOperationTest];
    [self initKnowledgePoints];
    [self operationWithQueue];
}
-(void)onlyOperationTest{
    ZHCustomOperation* operation = [[ZHCustomOperation alloc]init];
    [operation start];
}
-(void)operationWithQueue{
    ZHCustomOperation *op = [[ZHCustomOperation alloc] init];
    ZHOperationQueue *queue = [[ZHOperationQueue alloc] init];

    [queue addOperation:op];    // add 完 operation 就立即启动了
    [queue waitUntilAllOperationsAreFinished]; // 阻塞当前线程，直到所有的 operation 全都完成
    NSLog(@"Main Function");
}
-(void)initKnowledgePoints{
    self.knowledgePoints = @"整个 Operation 就是在当前的线程中以阻塞的形式执行的，当 operation 的 main 函数执行完毕之后，程序的控制权返回到主的 main 函数中。这样看来 operation 跟普通的一个函数调用就没有什么区别了。\n\
    对于并发的 Operation，要实现还是有点麻烦的，我们需要重载 start，isAsynchronous，isExecuting，isFinished 四个函数，同时还最好在 start 和 main 的实现中支持 cancel 操作。为什么要这么麻烦呢？因为对于一个并发的 Operation，调用者知道它什么时候开始，却不能知道它什么时候结束。在 NSOperation 的体系下，是通过 KVO 监测 isExecuting 和 isFinished 这几个变量，来监测 Operation 的完成状态的。出于兼容性的考虑（参考这里），我们还必须手动触发 KVO 通知。跟上面的非并发并没有什么本质的不同，完全取决于我们的 start 函数是如何实现的。这里我们的 start 函数中把任务直接扔给了另外的线程，也就不会阻塞当前线程了。\n\
    废了这么大劲，我们如何执行这个 Operation 呢？如果再像上面一样使用 [op start] 直接执行的话，你会发现还没等到 Operation 返回我们的整个程序就已经结束掉了。因为我们的主程序并不会等到 operatoin 返回。想要等到 operation 返回，我们还需要手动地去监视 operation 的变量，然后等待它返回。。。\n\
    看到这里你就明白为什么单独使用 NSOperation 发挥不了太大的作用了，因为 NSOperation 本身确实是没有做什么工作，大部分东西还是要靠我们自己来控制。这时候就需要 NSOperationQueue 登场了。\n\
    NSOperationQueue 是一个专门用于执行 NSOperation 的队列。在 OS X 10.6 之后，把一个 NSOperation 放到 NSOperationQueue 中，queue 会忽略 isAsynchronous 变量，总是会把 operation 放到后台线程中执行。这样不管 operation 是不是异步的，queue 的执行都是不会造成主线程的阻塞的。使用 Queue 可以很方便地进行并发操作，并且帮我们完成大部分的监视 operation 是否完成的操作。\n\
    添加各个各样的 operation 到 queue 中，只要这些 operation 都正确地重载了 isExecuting 和 isFinished，就可以正确地被并发执行。\n\
    除此之外，NSOperationQueue 还有几个很强大的特性。\n\
    Dependency\n\
    NSOperation 可以通过 addDependency 来依赖于其他的 operation 完成，如果有很多复杂的 operation，我们可以形成它们之间的依赖关系图，来实现复杂的同步操作：\n\
    [updateUIOperation addDependency: workerOperation];\n\
    Cancellation\n\
    NSOperation 有如下几种的运行状态：\n\
    Pending,\n\
    Ready,\n\
    Executing,\n\
    Finished,\n\
    Canceled,\n\
    除 Finished 状态外，其他状态均可转换为 Canceled 状态。\n\当 NSOperation 支持了 cancel 操作时，NSOperationQueue 可以使用 cancelAllOperatoins 来对所有的 operation 执行 cancel 操作。不过 cancel 的效果还是取决于 NSOperation 中代码是怎么写的。比如 对于数据库的某些操作线程来说，cancel 可能会意味着 你需要把数据恢复到最原始的状态。\n\
    maxConcurrentOperationCount\n\
    默认的最大并发 operation 数量是由系统当前的运行情况决定的(来源)，我们也可以强制指定一个固定的并发数量。\n\
    Queue 的优先级\n\
    NSOperationQueue 可以使用 queuePriority 属性设置优先级\n\注1：尽管系统会尽量使得优先级高的任务优先执行，不过并不能确保优先级高的任务一定会先于优先级低的任务执行，即优先级并不能保证任务的执行先后顺序。要先让一个任务先于另一个任务执行，需要使用设置dependency 来实现。\n\
    注2：同 NSOperation 一样，NSOperationQueue 也具有若干 QoS 选项可供选择。有关 QoS 配置的具体细节，例如当 NSOperation 和 NSOperationQueue 具有不同的 QoS 时出现的效果，以及如何改变 QoS 等，可以参考苹果官方文档 Energy Efficiency Guide for iOS Apps 。\n\GCD 与 NSOperation 的对比\n\
    这是面试中经常会问到的一点，这两个都很常用，也都很强大。对比它们可以从下面几个角度来说：\n\
    首先要明确一点，NSOperationQueue 是基于 GCD 的更高层的封装，从 OS X 10.10 开始可以通过设置 underlyingQueue 来把 operation 放到已有的 dispatch queue 中。\n\
    从易用性角度，GCD 由于采用 C 风格的 API，在调用上比使用面向对象风格的 NSOperation 要简单一些。\n\从对任务的控制性来说，NSOperation 显著得好于 GCD，和 GCD 相比支持了 Cancel 操作（注：在 iOS8 中 GCD 引入了 dispatch_block_cancel 和 dispatch_block_testcancel，也可以支持 Cancel 操作了），支持任务之间的依赖关系，支持同一个队列中任务的优先级设置，同时还可以通过 KVO 来监控任务的执行情况。这些通过 GCD 也可以实现，不过需要很多代码，使用 NSOperation 显得方便了很多。/n\n\
    从第三方库的角度，知名的第三方库如 AFNetworking 和 SDWebImage 背后都是使用 NSOperation，也从另一方面说明对于需要复杂并发控制的需求，NSOperation 是更好的选择（当然也不是绝对的，例如知名的 Parse SDK 就完全没有使用 NSOperation，全部使用 GCD，其中涉及到大量的 GCD 高级用法，这里有相关解析）。\n\n";
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
