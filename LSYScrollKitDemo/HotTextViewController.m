//
//  HotTextViewController.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/28.
//

#import "HotTextViewController.h"
#import "FakeDataFactory.h"
#import "Macro.h""

@interface HotTextCell : UITableViewCell

@property (nonatomic, strong) HotTextModel *model;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *authorLbl;
@property (nonatomic, strong) UILabel *publisherLbl;

@end

@implementation HotTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    CGFloat contentWidth = self.contentView.frame.size.width;
    
    UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 70, 93)];
    _coverImageView = coverImageView;
    coverImageView.backgroundColor = UIColorFromRGB(0xEAECF0);
    coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    coverImageView.clipsToBounds = YES;
    coverImageView.layer.cornerRadius = 8;
    [self.contentView addSubview:coverImageView];
    
    _nameLabel = [self createLblWithFont:[UIFont italicSystemFontOfSize:15] textColor:UIColorFromRGB(0x14161A)];
    _nameLabel.frame = CGRectMake(102, 19, contentWidth-122, 15);
    [self.contentView addSubview:_nameLabel];
    
    _authorLbl = [self createLblWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromRGB(0x73757B)];
    _authorLbl.frame = CGRectMake(102, 57, contentWidth-122, 12);
    [self.contentView addSubview:_authorLbl];
    
    _publisherLbl = [self createLblWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromRGB(0xA4A6AC)];
    _publisherLbl.frame = CGRectMake(102, 86, contentWidth-122, 12);
    [self.contentView addSubview:_publisherLbl];
}

- (UILabel *)createLblWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = textColor;
    return label;
}

- (void)bindWithModel:(HotTextModel *)model {
    _model = model;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imgUrl = [model.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateImageForModel:model data:data];
            });

        } else {
            _coverImageView.image = nil;
        }
    });
    self.nameLabel.text = model.name;
    self.authorLbl.text = model.author;
    self.publisherLbl.text = model.publisher;
}

- (void)updateImageForModel:(HotTextModel *)model data:(NSData *)data {
    if ([_model.imgUrl isEqualToString:model.imgUrl]) {
        _coverImageView.image = [UIImage imageWithData:data];
    } else {
        ;
    }
}

+ (CGFloat)cellHeight {
    return 117;
}

@end


@interface HotTextViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HotTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _tableView.frame = self.view.bounds;
}

- (void)setupData {
    _dataArray = [FakeDataFactory HotTextData];
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
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [self.view addSubview:tableView];
}

- (NSArray<UIScrollView *> *)currentScrollViews {
    return @[_tableView];
}

#pragma mark - - tableView delegate datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    HotTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HotTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell bindWithModel:_dataArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [HotTextCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
