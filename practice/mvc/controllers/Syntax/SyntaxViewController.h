//
//  SyntaxViewController.h
//  practice
//
//  Created by 张浩 on 2020/9/22.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SyntaxViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDragDelegate,UICollectionViewDropDelegate,UICollectionViewDataSourcePrefetching>
@property (weak, nonatomic) IBOutlet UICollectionView *syntaxCollectionView;

@end

NS_ASSUME_NONNULL_END
