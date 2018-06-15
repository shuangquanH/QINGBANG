//
//  OrderDeatilBottomPictureView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderDeatilBottomPictureView.h"
#import "OrderDeatilBottomPictureCollectionViewCell.h"//collectionViewCell
#import "KSPhotoBrowser.h"//图片查看器

@interface OrderDeatilBottomPictureView ()<UICollectionViewDelegate,UICollectionViewDataSource>
/** 图片描述  */
@property (nonatomic,strong) UILabel * descriptionLabel;
/** 图片collection  */
@property (nonatomic,strong) UICollectionView * pictureCollectionview;

@end

@implementation OrderDeatilBottomPictureView


- (void)setDataArray:(NSMutableArray *)dataArray{
    
        _dataArray = dataArray;
    
    [self.pictureCollectionview reloadData];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    OrderDeatilBottomPictureCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderDeatilBottomPictureCollectionViewCellID forIndexPath:indexPath];
    
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholderImage:YGDefaultImgSquare];
//    cell.pictureView.image = self.dataArray[indexPath.row];
    
    return cell;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//
//    return 1;
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDeatilBottomPictureCollectionViewCell * cell = (OrderDeatilBottomPictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    NSMutableArray *items = @[].mutableCopy;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        UIImageView *imageView = cell.pictureView;
        
        NSString * url = self.dataArray[i];

//        UIImage * img = self.dataArray[i];
        
//        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:img];
        KSPhotoItem *item = [KSPhotoItem  itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];

        [items addObject:item];
    }
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
   
    
    [browser showFromViewController:[cell getCellViewController]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}
- (void)setupUI{
    
    UILabel * noticeLabel = [UILabel ld_labelWithTextColor:LD9ATextColor textAlignment:NSTextAlignmentLeft font:LDFont(14) numberOfLines:1];
    noticeLabel.text = @"图片描述";
    
    noticeLabel.frame = CGRectMake(LDHPadding, 0, kScreenW - 2 * LDHPadding, 30);
    
    [self addSubview:noticeLabel];
    
    [self addSubview:self.pictureCollectionview];
  
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        //self.backgroundColor = kBlueColor;
    }
    return self;
}

static NSString * const OrderDeatilBottomPictureCollectionViewCellID = @"OrderDeatilBottomPictureCollectionViewCellID";

- (UICollectionView *)pictureCollectionview{
    if (!_pictureCollectionview) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake((kScreenW - 4 * LDHPadding - 1) / 3, 105);
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _pictureCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, kScreenW, self.height -30 ) collectionViewLayout:layout];
        _pictureCollectionview.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _pictureCollectionview.delegate = self;
        _pictureCollectionview.dataSource = self;
        _pictureCollectionview.backgroundColor = kWhiteColor;
        
        _pictureCollectionview.pagingEnabled = NO;
        _pictureCollectionview.showsHorizontalScrollIndicator = NO;
        _pictureCollectionview.showsVerticalScrollIndicator = NO;

        [_pictureCollectionview registerNib:[UINib nibWithNibName:@"OrderDeatilBottomPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:OrderDeatilBottomPictureCollectionViewCellID];
        
    }
    
    return _pictureCollectionview;
}

@end
