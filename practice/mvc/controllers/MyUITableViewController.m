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
    self.tableView.backgroundColor =[UIColor whiteColor];
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
    NSArray* array =@[@1,@2,@3,@4,@5,@6,@7,@8,@9];
    NSArray* array1 =@[@1,@3,@5,@7,@2,@4,@6];
    [self reOrderArray:array1];
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
    cell.backgroundColor = [UIColor whiteColor];
//    cell.contentView.backgroundColor = [UIColor whiteColor];
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
-(void)reOrderArray:(NSArray*)array {
    NSMutableArray* m_array = [NSMutableArray arrayWithArray:array];
    int oddIndex = 0;
    int evenIndex = 0;

    int lastOddIndex = 0;
    for(int i = 0;i<m_array.count;i++){
        int val = [m_array[i] intValue];
        if(val & 1 ){//val为奇数，无需处理，移动index
            lastOddIndex = i;
        }
        
    }
    for(int i = 0;i<m_array.count;i++){
        int val = [m_array[i] intValue];
        if(val & 1 ){//val为奇数，无需处理，移动index
            //ddIndex = i+1;//奇数应当在的位置
            //evenIndex = oddIndex+1;
            if (i == lastOddIndex) {
                return;
            }
        }else{
            oddIndex = i;//遇到偶数，从偶数后面找奇数来替换
            evenIndex = oddIndex+1;
            NSNumber* temp;//暂存
            NSNumber* tempPre = m_array[oddIndex];//暂存当前的偶数
            
            while(evenIndex<m_array.count){
                temp = m_array[evenIndex];//暂存目标
                if([temp intValue] & 1){//验证目标是否为奇数
                    m_array[oddIndex] = temp;//把之前的偶数赋值给奇数
                    m_array[evenIndex] = tempPre;//把奇数放在刚才偶数的位置
                    if (evenIndex == lastOddIndex) {
                        return;
                    }
                    break;//跳出循环
                }else{
                    //是偶数，整体往后挪，暂存被覆盖的数
                    
                    m_array[evenIndex] = tempPre;
                    
                }
                tempPre = temp;
                evenIndex++;
                
            }
        }
        
    }
    NSLog(@"%@",m_array);
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
