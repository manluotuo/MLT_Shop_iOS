//
//  SGMultiMenu.m
//  merchant
//
//  Created by mactive.meng on 25/6/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "SGMultiMenu.h"

#define kMAX_SHEET_TABLE_HEIGHT   340

@interface SGMultiMenu () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong)SGButton *doneDateButton;

@property (nonatomic, strong) void(^actionHandle)(NSMutableArray *);
@end


@implementation SGMultiMenu
@synthesize selectedItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseMenuBackgroundColor(self.style);
        
        self.selectedItems = [[NSMutableArray alloc]init];
        _items = [NSArray array];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = BaseMenuTextColor(self.style);
        [self addSubview:_titleLabel];
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_tableView];
        
        _doneDateButton = [SGButton buttonWithType:UIButtonTypeCustom];
        _doneDateButton.clipsToBounds = YES;
        _doneDateButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_doneDateButton setTitleColor:BaseMenuTextColor(self.style) forState:UIControlStateNormal];
        [_doneDateButton addTarget:self
                            action:@selector(tapAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        [_doneDateButton setTitle:@"完   成" forState:UIControlStateNormal];
        [self addSubview:_doneDateButton];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setupWithTitle:title items:itemTitles];
    }
    return self;
}

- (void)setupWithTitle:(NSString *)title items:(NSArray *)items
{
    _titleLabel.text = title;
    _items = items;
}

- (void)setStyle:(SGActionViewStyle)style{
    _style = style;
    
    self.backgroundColor = BaseMenuBackgroundColor(style);
    self.titleLabel.textColor = BaseMenuTextColor(style);
    [self.doneDateButton setTitleColor:BaseMenuActionTextColor(style) forState:UIControlStateNormal];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float height = 0;
    float table_top_margin = 0;
    float table_bottom_margin = 10;
    
    self.titleLabel.frame = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, 40)};
    height += self.titleLabel.bounds.size.height;
    height += table_top_margin;
    
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    float contentHeight = self.tableView.contentSize.height;
    if (contentHeight > kMAX_SHEET_TABLE_HEIGHT) {
        contentHeight = kMAX_SHEET_TABLE_HEIGHT;
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableView.scrollEnabled = NO;
    }
    
    self.tableView.frame = CGRectMake(self.bounds.size.width * 0.05, height, self.bounds.size.width * 0.9, contentHeight);
    height += self.tableView.bounds.size.height;
    
    self.doneDateButton.frame = CGRectMake(self.bounds.size.width*0.05, height, self.bounds.size.width*0.9, 44);

    height += 44;
    height += table_bottom_margin;

    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, height)};
}

#pragma mark -

- (void)triggerSelectedAction:(void(^)(NSMutableArray *))actionHandle
{
    self.actionHandle = actionHandle;
}

- (void)tapAction:(SGButton *)sender
{
    if (self.actionHandle) {
        double delayInSeconds = 0.15;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.actionHandle(self.selectedItems);
        });

    }
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = BaseMenuTextColor(self.style);
        cell.detailTextLabel.textColor = BaseMenuTextColor(self.style);
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSDictionary *cellData = self.items[indexPath.row];
    cell.textLabel.text = cellData[@"title"];
    if ([cellData[@"value"] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedItems addObject:INT(indexPath.row)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *cellData = self.items[indexPath.row];

    if(cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cellData[@"value"] = NUM_BOOL(YES);
        [self.selectedItems removeObject:INT(indexPath.row)];
    }
    else {
        cellData[@"value"] = NUM_BOOL(NO);
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedItems addObject:INT(indexPath.row)];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


@end
