//
//  MyUITableViewController.m
//  practice
//
//  Created by 张浩 on 2020/9/22.
//

#import "MyUITableViewController.h"
#import "AnimationModel.h"
@interface MyUITableViewController ()
@property(nonatomic,strong)NSArray* dataList;
@end

@implementation MyUITableViewController
-(instancetype)init{
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UI和动画";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _dataList = [AnimationModel getAnimationModels];
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyUITableViewCell" forIndexPath:indexPath];
    NSDictionary* dic = _dataList[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.textLabel.textColor = [UIColor blackColor];
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{//跳转到下一页
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic = _dataList[indexPath.row];
    if ([NSClassFromString(dic[@"target"]) isSubclassOfClass:[UIViewController class]]) {
        UIViewController* vc = nil;
        if(!dic[@"type"]){
            vc = [[NSClassFromString(dic[@"target"]) alloc] init];
            
        }else if ([@"nib" isEqualToString:dic[@"type"]]){
            vc = [[NSClassFromString(dic[@"target"]) alloc] initWithNibName:dic[@"key"] bundle:nil];
        }
        else if ([@"storyboard" isEqualToString:dic[@"target"]]){
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:dic[@"target"]];
            
        }else{
            vc = [[UIViewController alloc]init];
        }
        vc.title = dic[@"title"];
        [self showViewController:vc sender:self];
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
