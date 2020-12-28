//
//  ZHFileManagerViewController.m
//  practice
//
//  Created by 张浩 on 2020/12/28.
//

#import "ZHFileManagerViewController.h"

@interface ZHFileManagerViewController ()

@end

@implementation ZHFileManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initKnowlodge];
    // Do any additional setup after loading the view from its nib.
}
-(void)initKnowlodge{
    self.knowledgePoints = @"沙盒机制根据访问权限和功能区别分为不同的目录: \n\
    document,library,temp,.app, library又包含 caches 和preferences.\n\
    document: 保存应用运行时生成的需要持久化的数据iTunes会自动备份该目录。苹果建议将在应用程序中浏览到的文件数据保存在该目录下\n\
    1、library: 这个目录下有两个目录\n\
    2、caches: 一般存储的是缓存文件，例如图片视频等，此目录下的文件不会再应用程序退出时删除，在手机备份的时候，iTunes不会备份该目录。\n\
    3、preferences: 保存应用程序的所有偏好设置iOS的Settings(设置)，我们不应该直接在这里创建文件，而是需要通过NSUserDefault这个类来访问应用程序的偏好设置。iTunes会自动备份该文件目录下的内容.";
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
