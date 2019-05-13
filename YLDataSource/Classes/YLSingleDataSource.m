//
//  YLSingleDataSource.m
//  YLDataSource
//
//  Created by Yangli on 2019/5/8.
//

#import "YLSingleDataSource.h"

@interface YLSingleDataSource ()
@property (nonatomic, strong) IBInspectable NSString *cellIdentifier;
@property (nonatomic, copy) yl_cellConfigureBefore yl_cellConfigureBefore;
@property (nonatomic, copy) yl_selectCellBlock yl_selectBlock;
@property (nonatomic, strong) UIImage *yl_emptyImage;
@property (nonatomic, strong) NSAttributedString *yl_emptyTitle;
@property (nonatomic, copy) yl_emptyTapAction yl_emptyActionBlock;
@property (nonatomic, copy) yl_reloadBlock yl_reloadBlock;

@end

@implementation YLSingleDataSource

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)addDataArray:(NSArray *)datas
{
    if(!datas) return;
    
    [self.dataSource addObjectsFromArray:datas];
}

- (void)refreshDataArray:(NSArray *)datas
{
    if(!datas) return;
    
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    [self.dataSource addObjectsFromArray:datas];
}

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource.count > indexPath.row ? self.dataSource[indexPath.row] : nil;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                    configureBlock:(yl_cellConfigureBefore)configure
                       selectBlock:(yl_selectCellBlock)selectBlock
                        reloadData:(yl_reloadBlock)reloadData
{
    self = [super init];
    if(self) {
        _cellIdentifier = identifier;
        _yl_cellConfigureBefore = [configure copy];
        _yl_selectBlock = [selectBlock copy];
        _yl_reloadBlock = [reloadData copy];
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                    configureBlock:(yl_cellConfigureBefore)configure
                        emptyImage:(UIImage *)emptyImage
                        emptyTitle:(NSAttributedString *)emptyTitle
                       selectBlock:(yl_selectCellBlock)selectBlock
                       emptyAction:(yl_emptyTapAction)emptyAction
                        reloadData:(yl_reloadBlock)reloadData
{
    self = [super init];
    if (self) {
        _cellIdentifier = identifier;
        _yl_cellConfigureBefore = [configure copy];
        _yl_emptyImage = [emptyImage copy];
        _yl_emptyTitle = [emptyTitle copy];
        _yl_selectBlock = [selectBlock copy];
        _yl_emptyActionBlock = [emptyAction copy];
        _yl_reloadBlock = [reloadData copy];
    }
    return self;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return !self.dataSource ? 0: self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id model = [self modelsAtIndexPath:indexPath];
    if(self.yl_cellConfigureBefore) {
        self.yl_cellConfigureBefore(cell, model,indexPath);
    }
    return cell;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return !self.dataSource  ? 0: self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id model = [self modelsAtIndexPath:indexPath];
    
    if(self.yl_cellConfigureBefore) {
        self.yl_cellConfigureBefore(cell, model,indexPath);
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 将点击事件通过block的方式传递出去
    if (self.yl_selectBlock) {
        self.yl_selectBlock(indexPath, self.dataSource[indexPath.row]);
    }
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 将点击事件通过block的方式传递出去
    if (self.yl_selectBlock) {
        self.yl_selectBlock(indexPath, self.dataSource[indexPath.row]);
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(self) weakSelf = self;
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        //在这里添加点击事件
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        weakSelf.yl_reloadBlock([weakSelf.dataArray copy]);
    }];
    //    // 添加一个编辑按钮
    //    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"复制"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    //        //
    //
    //        //在这里添加点击事件
    //        [weakSelf.dataArray insertObject:weakSelf.dataArray[indexPath.row] atIndex:indexPath.row];
    //        weakSelf.reloadData(weakSelf.dataArray);
    //    }];
    //    topRowAction.backgroundColor = [UIColor cyanColor];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction];
}

#pragma mark ============================    DZNEmptyDataSetDelegate    ============================
//空白页占位图
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.yl_emptyImage) {
        return _yl_emptyImage;
    }
    return [UIImage imageNamed:@"yl_icon_null"];
}

//空白页标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.yl_emptyTitle) {
        return _yl_emptyTitle;
    }
    NSString *text = @"暂无数据";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

////空白页按钮点击事件
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
//{
//
//}

//空白页点击事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (self.yl_emptyActionBlock) {
        self.yl_emptyActionBlock(YES);
    }
}

@end
