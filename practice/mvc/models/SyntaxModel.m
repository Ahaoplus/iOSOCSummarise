//
//  SyntaxModel.m
//  practice
//
//  Created by 张浩 on 2020/10/7.
//

#import "SyntaxModel.h"

@implementation SyntaxModel
+(NSArray*)getSyntaxModels{
    return @[
        @{@"key":@"objective-c-basic",@"title":@"Objective-C基础",@"children":@[
              @{@"key":@"ZHKeywordsViewController",@"title":@"关键字",@"icon":@"",@"authCode":@""},
              @{@"key":@"ZHOOViewController",@"type":@"nib",@"title":@"类和对象",@"icon":@"",@"authCode":@""},
              @{@"key":@"ZHGDCViewController",@"type":@"nib",@"title":@"GDC",@"icon":@"",@"authCode":@""},
              @{@"key":@"ZHBlockViewController",@"type":@"nib",@"title":@"Block编程",@"icon":@"",@"authCode":@""},
              @{@"key":@"ZHRuntimeViewController",@"type":@"nib",@"title":@"Runtime",@"icon":@"",@"authCode":@""},
              @{@"key":@"key0-3",@"title":@"内存管理",@"icon":@"",@"authCode":@""},
              @{@"key":@"ZHRunloopViewController",@"type":@"nib",@"title":@"Runloop",@"icon":@"",@"authCode":@""},
              @{@"key":@"ZHFileManagerViewController",@"type":@"nib",@"title":@"文件IO",@"icon":@"",@"authCode":@""}
            ]
        },
        @{@"key":@"newpoint",@"title":@"新特性",@"children":@[
    @{@"key":@"UniversalLinkViewController",@"type":@"nib",@"title":@"Universal\nLink",@"icon":@"",@"authCode":@""},
    @{@"key":@"ZHOperationViewController",@"type":@"nib",@"title":@"NSOperation",@"icon":@"",@"authCode":@""},],
              },
        @{@"key":@"newpoint",@"title":@"第三方库源码及使用",@"children":@[
    @{@"key":@"ZHFMDBViewController",@"type":@"nib",@"title":@"FMDB",@"icon":@"",@"authCode":@""},
    @{@"key":@"ZHAFNViewController",@"type":@"nib",@"title":@"AFN",@"icon":@"",@"authCode":@""},],
              },
        @{@"key":@"computer-network",@"title":@"计算机网络",@"children":@[
                  @{@"key":@"key1-0",@"title":@"HTTP协议",@"icon":@"",@"authCode":@"",@"url":@"https://www.zhihu.com/question/34074946"},
              @{@"key":@"key1-1",@"title":@"HTTPS",@"icon":@"",@"authCode":@""},
              @{@"key":@"key1-2",@"title":@"TCP/IP协议",@"icon":@"",@"authCode":@""},
              @{@"key":@"key1-4",@"title":@"UDP协议",@"icon":@"",@"authCode":@""},
              @{@"key":@"key1-5",@"title":@"Socket编程",@"icon":@"",@"authCode":@""}
            ]
        },
        @{@"key":@"section1",@"title":@"数据结构与算法",@"children":@[
                  @{@"key":@"key2-0",@"title":@"链表",@"icon":@"",@"authCode":@""},
                  @{@"key":@"key2-1",@"title":@"树",@"icon":@"",@"authCode":@""},
                  @{@"key":@"key2-2",@"title":@"哈希表",@"icon":@"",@"authCode":@""},
                  @{@"key":@"key2-3",@"title":@"排序",@"icon":@"",@"authCode":@""},
                  @{@"key":@"key2-4",@"title":@"搜索",@"icon":@"",@"authCode":@""},
                  @{@"key":@"key2-5",@"title":@"字符串",@"icon":@"",@"authCode":@""},
                  @{@"key":@"key2-5",@"title":@"向量/矩阵",@"icon":@"",@"authCode":@""},
                  @{@"key":@"key2-5",@"title":@"随机",@"icon":@"",@"authCode":@""},
                  @{@"key":@"key2-5",@"title":@"贪心",@"icon":@"",@"authCode":@""},
                  @{@"key":@"key2-5",@"title":@"动态规划",@"icon":@"",@"authCode":@""}]
        },
        @{@"key":@"section2",@"title":@"体系结构与操作系统",@"children":@[
              @{@"key":@"",@"title":@"体系结构基础",@"icon":@"",@"authCode":@""},
              @{@"key":@"",@"title":@"操作系统基础",@"icon":@"",@"authCode":@""},
              @{@"key":@"",@"title":@"并发技术",@"icon":@"",@"authCode":@""},
              @{@"key":@"",@"title":@"内存管理",@"icon":@"",@"authCode":@""},
              @{@"key":@"",@"title":@"磁盘与文件",@"icon":@"",@"authCode":@""},
              @{@"key":@"",@"title":@"编译器架构",@"icon":@"",@"authCode":@""},
            ]
        },
    ];
    
}
@end
