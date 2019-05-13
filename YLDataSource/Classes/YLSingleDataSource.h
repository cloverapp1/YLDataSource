//
//  YLSingleDataSource.h
//  YLDataSource
//
//  Created by Yangli on 2019/5/8.
//


#import <Foundation/Foundation.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^yl_cellConfigureBefore)(id _Nonnull cell, id _Nonnull model, NSIndexPath *_Nonnull indexPath);
typedef void(^yl_selectCellBlock)(NSIndexPath *_Nonnull indexPath, id _Nonnull model);
typedef void(^yl_reloadBlock)(NSMutableArray *_Nonnull sourceArray);
typedef void(^yl_emptyImage)(UIImage *_Nonnull image);
typedef void(^yl_emptyTitle)(NSAttributedString *_Nonnull title);
typedef void(^yl_emptyTapAction)(BOOL refresh);


/**
 单样式cell处理工具
 */
@interface YLSingleDataSource : NSObject<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 追加数据源

 @param datas 追加数据源数组
 */
- (void)addDataArray:(NSArray *)datas;

/**
 刷新数据源

 @param datas 待刷新数据源
  该数据源为空是不进行清空源数据源操作
 */
- (void)refreshDataArray:(NSArray *)datas;

/**
 返回indexPath的模型

 @param indexPath indexPath
 @return model模型
 */
- (id)modelsAtIndexPath:(NSIndexPath *)indexPath;

/**
 快捷配置
 
 @param identifier 重用标识
 @param configure cell配置
 @param selectBlock 选中回调
 @param reloadData 增删数据源回调
 @return YLDataSource实例
 */
- (instancetype)initWithIdentifier:(NSString *)identifier
                    configureBlock:(yl_cellConfigureBefore)configure
                       selectBlock:(yl_selectCellBlock)selectBlock
                        reloadData:(yl_reloadBlock)reloadData;

/**
 含空视图快捷配置
 
 @param identifier 重用标识
 @param configure cell配置
 @param emptyImage 无数据显示图
 @param emptyTitle 无数据富文本提示文字
 @param selectBlock 选中回调
 @param emptyAction 空视图点击回调
 @param reloadData 增删数据源回调
 @return YLDataSource实例
 */
- (instancetype)initWithIdentifier:(NSString *)identifier
                    configureBlock:(yl_cellConfigureBefore)configure
                        emptyImage:(UIImage *)emptyImage
                        emptyTitle:(NSAttributedString *)emptyTitle
                       selectBlock:(yl_selectCellBlock)selectBlock
                       emptyAction:(yl_emptyTapAction)emptyAction
                        reloadData:(yl_reloadBlock)reloadData;
@end

NS_ASSUME_NONNULL_END
