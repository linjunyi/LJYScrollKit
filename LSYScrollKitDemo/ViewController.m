//
//  ViewController.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/27.
//

#import "ViewController.h"
#import "ShareHeaderDemoVC.h"
#import "ScrollPageHandlerDemoVC.h"

static NSString *kTitleKey = @"titleKey";
static NSString *kSelectorKey = @"selectorKey";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataAry;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView = tableView;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 84)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [self.view addSubview:tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (NSArray *)dataAry {
    if (_dataAry == nil) {
        _dataAry = @[
            @{kTitleKey : @"多级scrollview嵌套", kSelectorKey:NSStringFromSelector(@selector(showShareHeaderVC))},
            @{kTitleKey : @"为任意view添加左右翻页功能", kSelectorKey:NSStringFromSelector(@selector(showScrollPageHandlerVC))},
            @{kTitleKey : @"自定义样式menu", kSelectorKey:NSStringFromSelector(@selector(showShareHeaderVC))},
            @{kTitleKey : @"单页面包含多个子功能页面", kSelectorKey:NSStringFromSelector(@selector(showShareHeaderVC))},
        ];
    };
    return _dataAry;
}

#pragma mark - TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = self.dataAry[indexPath.row];
    cell.textLabel.text = dic[kTitleKey];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataAry[indexPath.row];
    SEL selector = NSSelectorFromString(dic[kSelectorKey]);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector];
    }
}


#pragma mark -

- (void)showShareHeaderVC {
    ShareHeaderDemoVC *vc = [ShareHeaderDemoVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showScrollPageHandlerVC {
    ScrollPageHandlerDemoVC *vc = [ScrollPageHandlerDemoVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
