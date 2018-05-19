//
//  SQDecorationServeVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationServeVC.h"

#import "SQDecorationServeCell.h"
#import "SQDecorationSeveTableHeader.h"

@interface SQDecorationServeVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SQDecorationSeveTableHeader       *header;
@property (nonatomic, strong) SQBaseTableView       *tableview;

@end

@implementation SQDecorationServeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"装修直通车";
    UIBarButtonItem *itme = [self createBarbuttonWithNormalImageName:@"mine_instashot" selectedImageName:@"mine_instashot" selector:nil];
    self.navigationItem.rightBarButtonItem = itme;
    
    self.tableview.tableHeaderView = self.header;
    [self.view addSubview:self.tableview];
    [_header loadImage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationServeCell *cell = [SQDecorationServeCell cellWithTableView:tableView];
    cell.model = @[@"dd"];
    return cell;
}


#pragma mark LazyLoad
- (SQBaseTableView  *)tableview {
    if (!_tableview) {
        _tableview = [[SQBaseTableView   alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-KNAVHEIGHT)];
        _tableview.estimatedRowHeight = 600;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}
- (SQDecorationSeveTableHeader *)header {
    if (!_header) {
        _header = [[SQDecorationSeveTableHeader alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 200)];
    }
    return _header;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
