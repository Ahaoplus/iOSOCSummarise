//
//  SyntaxCollectionViewController.m
//  practice
//
//  Created by 张浩 on 2020/9/22.
//

#import "SyntaxCollectionViewController.h"
#import "SyntaxCollectionViewCell.h"
#import "SyntaxModel.h"
#import "SyntaxCollectionReusableView.h"
@interface SyntaxCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,/*UICollectionViewDropDelegate,UICollectionViewDragDelegate,*/UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSArray* dataArray;
@end

@implementation SyntaxCollectionViewController

static NSString * const reuseIdentifier = @"SyntaxCollectionViewCell";
static NSString * const reuseHeaderIdentifier = @"CollectionViewHeader";
static NSString * const reuseFooterIdentifier = @"CollectionViewFooter";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [SyntaxModel getSyntaxModels];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SyntaxCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SyntaxCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier];
    [self.collectionView reloadData];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.dataArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [(NSArray*)(self.dataArray[section][@"children"]) count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dic = (NSDictionary*)((NSArray*)(self.dataArray[indexPath.section][@"children"])[indexPath.item]);
    SyntaxCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
//    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.text = dic[@"title"];
    return cell;
}
// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString: UICollectionElementKindSectionFooter]) {
        //footer
        UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseFooterIdentifier forIndexPath:indexPath];
        return view;
    }else{
        //header
        SyntaxCollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
//        [collectionView dequeueReusableSupplementaryViewOfKind:<#(nonnull NSString *)#> withReuseIdentifier:<#(nonnull NSString *)#> forIndexPath:<#(nonnull NSIndexPath *)#>];
        view.titleLabel.text = self.dataArray[indexPath.section][@"title"];
        return view;
    }
    
}
#pragma mark <UICollectionViewDelegateFlowLayout>

/// 针对每个indexPath的Cell都可以设置size
/// @param collectionView collectionView
/// @param collectionViewLayout layout
/// @param indexPath 某个indexPath
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 80);
}
//section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    if(section == 1)
//        return UIEdgeInsetsMake(0, 20, 10, 10);  //margin 上右下左
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//section之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section%2 == 0) {
        return 10;
    }
    return 20;
}
//当前section里item之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    if (section==0) {
//        return 20;
//    }
//    return 10;
//}

/// section的header 大小
/// @param collectionView collectionView
/// @param collectionViewLayout collectionViewLayout
/// @param section section
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(320, 40);
}
//section的footer 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == self.dataArray.count-1) {
        return CGSizeMake(10, 10);
    }
    return CGSizeMake(0, 0);
}
#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = (NSDictionary*)((NSArray*)(self.dataArray[indexPath.section][@"children"])[indexPath.item]);
    if ([NSClassFromString(dic[@"key"]) isSubclassOfClass:[UIViewController class]]) {
        UIViewController* vc = nil;
        if(!dic[@"type"]){
            vc = [[NSClassFromString(dic[@"key"]) alloc] init];
            
        }else if ([@"nib" isEqualToString:dic[@"type"]]){
            vc = [[NSClassFromString(dic[@"key"]) alloc] initWithNibName:dic[@"key"] bundle:nil];
            
        }
        else if ([@"storyboard" isEqualToString:dic[@"type"]]){
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:dic[@"key"]];
            
        }else{
            vc = [[UIViewController alloc]init];
        }
        [self showViewController:vc sender:self];
        
    }
}
/*
// 使某些cell高亮显示
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
// 使某些cell被选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


/*
- (void)collectionView:(nonnull UICollectionView *)collectionView performDropWithCoordinator:(nonnull id<UICollectionViewDropCoordinator>)coordinator {
    
}

- (nonnull NSArray<UIDragItem *> *)collectionView:(nonnull UICollectionView *)collectionView itemsForBeginningDragSession:(nonnull id<UIDragSession>)session atIndexPath:(nonnull NSIndexPath *)indexPath {
    
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeMake(100, 100);
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return false;
}

- (void)updateFocusIfNeeded {
    
}
*/
@end
