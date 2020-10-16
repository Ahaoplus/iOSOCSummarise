//
//  BaseViewController.m
//  practice
//
//  Created by 张浩 on 2020/9/22.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"知识点" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    // Do any additional setup after loading the view.
}
-(void)rightAction{
    //弹出Alert显示知识点
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"本页知识点" message:(self.knowledgePoints ? self.knowledgePoints: @"暂无信息") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"OK Action");
        }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"Cancel Action");
//        }];

    [alertController addAction:okAction];           // A
//    [alertController addAction:cancelAction];       // B
    [self presentViewController:alertController animated:YES completion:^{
            
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
