//
//  RightMenuViewController.m
//  bitmedia
//
//  Created by meng qian on 14-1-20.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "RightMenuViewController.h"

@interface RightMenuViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation RightMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect tableViewFrame = self.view.bounds;
    
    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.backgroundColor = BlACKCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor blackColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:self.tableView];

    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:BlACKCOLOR];
    }
    else {
        [self.navigationController.navigationBar setTintColor:BlACKCOLOR];
    }

}

- (void)changeVehicleCloudStatus:(NSInteger)vehicleCloudStatus
{
    NSDictionary *dictA = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"一键分发"), @"title",
                           ICON_SHARE, @"icon",
                           INT(RightMenuSend), @"function",
                           nil];
    
    NSDictionary *dictB = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"发布历史"), @"title",
                           ICON_LIST, @"icon",
                           INT(RightMenuSendLog), @"function",
                           nil];
    
    // Do any additional setup after loading the view.
    NSDictionary *dictC = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"编辑"), @"title",
                           ICON_PENCIL, @"icon",
                           INT(RightMenuEdit), @"function",
                           nil];
    
    NSDictionary *dictD = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"删除"), @"title",
                           ICON_TRASH, @"icon",
                           INT(RightMenuDelete), @"function",
                           nil];
    
    NSDictionary *dictE = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"设为下架"), @"title",
                           ICON_COLUD_OFFLINE, @"icon",
                           INT(RightMenuOffline), @"function",
                           nil];
    
    NSDictionary *dictF = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"设为上架"), @"title",
                           ICON_ARROW_UP, @"icon",
                           INT(RightMenuOnline), @"function",
                           nil];
    

    switch (vehicleCloudStatus) {
        case VehicleCloudLocal:
            self.dataSource = [[NSMutableArray alloc]initWithObjects: dictC,dictD,dictF, nil];
            break;
        case VehicleCloudOnline:
            self.dataSource = [[NSMutableArray alloc]initWithObjects: dictA,dictD,dictE, nil];
            break;
        case VehicleCloudOffline:
            self.dataSource = [[NSMutableArray alloc]initWithObjects: dictD,dictE, nil];
            break;
        case VehicleCloudSold:
            self.dataSource = [[NSMutableArray alloc]initWithObjects: dictD,dictE, nil];
            break;
        default:
            self.dataSource = [[NSMutableArray alloc]initWithObjects: dictC,dictD,dictF, nil];
            break;
    }
    
    [self.tableView reloadData];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LeftSettingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [self tableViewCellWithReuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}


- (UITableViewCell *)tableViewCellWithReuseIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 40 ,40)];
    iconLabel.tag = CELL_ICON_TAG;
    iconLabel.font = FONT_AWESOME_24;
    iconLabel.textColor = WHITECOLOR;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 100, 40)];
    titleLabel.tag = CELL_TITLE_TAG;
    titleLabel.font = FONT_BLACK_15;
    titleLabel.textColor = WHITECOLOR;
    
    UILabel *bubbleLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 20, 90, 20)];
    
    [bubbleLabel setBackgroundColor:REDCOLOR];
    [bubbleLabel setTextColor:WHITECOLOR];
    [bubbleLabel setFont:FONT_12];
    [bubbleLabel setTextAlignment:NSTextAlignmentCenter];
    [bubbleLabel setHidden:YES];
    bubbleLabel.tag = CELL_BUBBLE_TAG;
    [bubbleLabel setHidden:YES];
    
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:iconLabel];
    [cell.contentView addSubview:bubbleLabel];
    [cell.contentView setBackgroundColor:BlACKCOLOR];
    [cell setBackgroundColor:BlACKCOLOR];
    
    return  cell;
}



- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    // two type
    NSDictionary *cellData = [[NSDictionary alloc]init];
    cell.contentView.backgroundColor = BlACKCOLOR;
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = DARKCOLOR;
    cell.selectedBackgroundView = selectionColor;
    
    cellData = [self.dataSource objectAtIndex:indexPath.row];
    
    UILabel *iconLabel = (UILabel *)[cell viewWithTag:CELL_ICON_TAG];
    iconLabel.text = [cellData objectForKey:@"icon"];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:CELL_TITLE_TAG];
    titleLabel.text = [cellData objectForKey:@"title"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellData = (NSDictionary *)[self.dataSource objectAtIndex:indexPath.row];
    NSInteger function = [(NSNumber *)[cellData objectForKey:@"function"] integerValue];
    
    switch (function) {
        case RightMenuSend:
            //
            break;
        case RightMenuSendLog:
            //
            break;
        case RightMenuEdit:
            //
            break;
        case RightMenuDelete:
            //
            break;
        case RightMenuOffline:
            //
            break;
        case RightMenuOnline:
            //
            break;
        default:
            break;
    }
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //
    }];

}


@end
