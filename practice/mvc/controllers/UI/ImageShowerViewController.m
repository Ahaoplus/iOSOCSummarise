//
//  ImageShowerViewController.m
//  practice
//
//  Created by 张浩 on 2021/5/9.
//

#import "ImageShowerViewController.h"
#import "TabScrollview.h"
#import "TabContentView.h"
#import "ImageShowerSubViewController.h"
#import "Masonry.h"
@interface ImageShowerViewController ()
@property (nonatomic,strong)TabScrollview *tabScrollView;
@property (nonatomic,strong)TabContentView *tabContent;
@property (nonatomic,strong)NSMutableArray *tabs;
@property (nonatomic,strong)NSMutableArray *contents;
@end

@implementation ImageShowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone; //系统默认值,系统布局需要从状态栏开始
    self.navigationController.navigationBar.translucent = YES;
    //ios6之前默认为no,ios6之后默认为ysa,NO的时候,,布局就会自动从状态栏下方开始,我们布局直接从状态栏开始,无下移ß下64
//    //创建模拟数据
    
    _tabs=[[NSMutableArray alloc]initWithCapacity:3];
    _contents=[[NSMutableArray alloc]initWithCapacity:3];
    
    NSArray* titles = @[@"视频",@"图集1",@"图集2",@"图集3"];//外部参数
    NSArray* tags = @[@"video",@"images1",@"images2",@"images3"];
    for(int i=0;i<titles.count;i++){
        
        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.text=titles[i];
        tab.textColor=[UIColor systemBackgroundColor];
        [_tabs addObject:tab];
        ImageShowerSubViewController *con=[ImageShowerSubViewController new];
        con.fatherController = self;
        con.tag = tags[i];
        [_contents addObject:con];
    }
    
    _tabScrollView=[[TabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabScrollView];
    [_tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideTop);
    }];

    [_tabScrollView configParameter:horizontal viewArr:_tabs tabWidth:60 tabHeight:50 index:0 block:^(NSInteger index) {

        [self->_tabContent updateTab:index];
    }];
    
    
    _tabContent=[[TabContentView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabContent];

    [_tabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self->_tabScrollView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    [_tabContent configParam:_contents Index:0 block:^(NSInteger index) {
        [self->_tabScrollView updateTagLine:index];
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
