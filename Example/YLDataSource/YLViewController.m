//
//  YLViewController.m
//  YLDataSource
//
//  Created by 2510479687@qq.com on 05/08/2019.
//  Copyright (c) 2019 2510479687@qq.com. All rights reserved.
//

#import "YLViewController.h"
#import "YLDataSource.h"


@interface YLViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YLSingleDataSource *dataSource;



@end

@implementation YLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self dataSourceConfig];
    
    [self.dataSource addDataArray:@[]];
}

- (void)dataSourceConfig
{
    self.tableView.tableFooterView = [UIView new];
    NSString *text = @"查询不到数据";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]};
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    self.dataSource = [[YLSingleDataSource alloc] initWithIdentifier:@"UITableViewCell"
                                                      configureBlock:^(UITableViewCell *cell, NSString *title, NSIndexPath * _Nonnull indexPath) {
                                                          cell.textLabel.text = title;
                                                      }
                                                          emptyImage:[UIImage imageNamed:@"yl_icon_null"]
                                                          emptyTitle:title
                                                         selectBlock:^(NSIndexPath * _Nonnull indexPath, id  _Nonnull model) {
                                                             
                                                         }
                                                         emptyAction:^(BOOL refresh) {
                                                             if (refresh) {
                                                                 [self refreshMethod];
                                                             }
                                                         }
                                                          reloadData:^(NSMutableArray * _Nonnull sourceArray) {
                                                              [self.dataSource addDataArray:sourceArray];
                                                              [self.tableView reloadData];
                                                          }];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    self.tableView.emptyDataSetSource = self.dataSource;
    self.tableView.emptyDataSetDelegate = self.dataSource;
}

- (void)refreshMethod
{
    [self.dataSource addDataArray:@[@"Object-C",@"Swift",@"Java",@"Python"]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
