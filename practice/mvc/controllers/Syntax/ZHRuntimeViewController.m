//
//  ZHRuntimeViewController.m
//  practice
//
//  Created by 张浩 on 2020/10/28.
//

#import "ZHRuntimeViewController.h"
typedef enum {
    ZHOptionsFirst = 1<<0,
    ZHOptionsSecond = 1<<2,
    ZHOptionsThird = 1<<3,
    ZHOptionsForth = 1<<4,
} ZHOptionsEnum;

@interface ZHRuntimeViewController ()

@end

@implementation ZHRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setOptions:ZHOptionsForth | ZHOptionsFirst | ZHOptionsThird ];
}

-(void)setOptions:(ZHOptionsEnum)options {
    if (options & ZHOptionsFirst) {
        NSLog(@"contains ZHOptionsFirst");
    }
    if (options & ZHOptionsSecond) {
        NSLog(@"contains ZHOptionsSecond");
    }
    if (options & ZHOptionsThird) {
        NSLog(@"contains ZHOptionsThird");
    }
    if (options & ZHOptionsForth) {
        NSLog(@"contains ZHOptionsForth");
    }
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
