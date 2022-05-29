//
//  HotTextViewController.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/28.
//

#import "ChildDemoVC.h"
#import "Macro.h"


@interface ChildDemoVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger listCount;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ChildDemoVC

- (id)initWithIndex:(NSInteger)index listCount:(NSInteger)listCount {
    if (self = [super init]) {
        _index = index;
        _listCount = listCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _tableView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGPoint contentOffset = _tableView.contentOffset;
    _tableView.frame = self.view.bounds;
    _tableView.contentOffset = contentOffset;
    [_tableView reloadData];
}

- (void)setupView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView = tableView;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [self.view addSubview:tableView];
}

- (UIScrollView *)currentScrollView {
    return _tableView;
}

#pragma mark - - tableView delegate datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"列表%zd item%zd", _index, indexPath.row+1];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
