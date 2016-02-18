//
//  AreaPickerViewController.m
//  merchant
//
//  Created by mactive.meng on 12/5/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "AreaPickerViewController.h"
#import "UIViewController+ImageBackButton.h"
#import "MultiTablesView.h"
#import "FAIconButton.h"
#import "AppRequestManager.h"

@interface AreaPickerViewController ()<MultiTablesViewDataSource, MultiTablesViewDelegate, PassValueDelegate>

@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)AddressModel *pickedModel;
@property(assign, nonatomic)NSInteger nowPick;
@property(strong, nonatomic)NSMutableArray *pickerDataSource;
@property(strong, nonatomic)MultiTablesView* multiTableView;
@property(strong, nonatomic)FAIconButton *sendButton;
@property(assign, nonatomic)BOOL showNoLimitButton;

@end


#define STEP_ONE        0
#define STEP_TWO        1
#define STEP_THREE      2
#define STEP_FOUR       3
#define LINE_WIDTH      1.0

@implementation AreaPickerViewController
@synthesize tableView;
@synthesize pickedModel;
@synthesize nowPick;
@synthesize pickerDataSource;
@synthesize passDelegate;
@synthesize sendButton, showNoLimitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = WHITECOLOR;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // titleview
    self.title = T(@"选择地区");
    
    self.pickedModel = [[AddressModel alloc]initWithDict:nil];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    CGRect multiTableViewFrame;
    if (OSVersionIsAtLeastiOS7()) {
        multiTableViewFrame = CGRectMake(0, IOS7_CONTENT_OFFSET_Y, TOTAL_WIDTH, TOTAL_HEIGHT-IOS7_CONTENT_OFFSET_Y);
    }else {
        multiTableViewFrame = CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y);
    }

    self.multiTableView = [[MultiTablesView alloc]initWithFrame:multiTableViewFrame];
    self.multiTableView.delegate = self;
    self.multiTableView.dataSource = self;
    
    [self.view addSubview:self.multiTableView];
    

    self.pickerDataSource = [[NSMutableArray alloc]initWithObjects:[[NSMutableArray alloc]init],[[NSMutableArray alloc]init],[[NSMutableArray alloc]init], nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self dataSourceWithLevel:STEP_ONE];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dataSourceWithLevel:(NSInteger)level
{
    if (level == STEP_ONE) {
        
        [[AppRequestManager sharedManager]getAreaWithParentID:self.pickedModel.countryCode andBlock:^(id responseObject, NSError *error) {
            //
            if (responseObject != nil) {
                for (NSDictionary *dict in responseObject) {
                    AddressModel *model = [[AddressModel alloc] initWithDict:dict];
                    model.name = dict[@"name"];
                    model.code = dict[@"id"];
                    [self.pickerDataSource[0] addObject:model];
                }
                [self.multiTableView.currentTableView reloadData];
            }

        }];
    }
    
    if (level == STEP_TWO) {
        [self.pickerDataSource[1] removeAllObjects];
        
        [[AppRequestManager sharedManager]getAreaWithParentID:self.pickedModel.provinceCode andBlock:^(id responseObject, NSError *error) {
            //
            if (responseObject != nil) {
                for (NSDictionary *dict in responseObject) {
                    AddressModel *model = [[AddressModel alloc] initWithDict:dict];
                    model.name = dict[@"name"];
                    model.code = dict[@"id"];
                    [self.pickerDataSource[1] addObject:model];
                }
                [self.multiTableView.currentTableView reloadData];
            }
            
        }];
    }
    
    if (level == STEP_THREE) {
        [self.pickerDataSource[2] removeAllObjects];
        
        [[AppRequestManager sharedManager]getAreaWithParentID:self.pickedModel.cityCode andBlock:^(id responseObject, NSError *error) {
            //
            if (responseObject != nil) {
                for (NSDictionary *dict in responseObject) {
                    AddressModel *model = [[AddressModel alloc] initWithDict:dict];
                    model.name = dict[@"name"];
                    model.code = dict[@"id"];
                    [self.pickerDataSource[2] addObject:model];
                }
                [self.multiTableView.currentTableView reloadData];
            }
        }];

    }
}

/////////////////////////////////////////////////////////
#pragma mark - 显示构造器
/////////////////////////////////////////////////////////

/**
 *  根据步骤来 构造显示项目
 *
 *  @param model 车辆信息
 *  @param step  步骤
 *
 *  @return 数据
 */

- (NSString *)makePickerStringWithModel:(AddressModel *)model andLevel:(NSInteger)level
{
    if (level == 0) {
        return model.name;
    }else if( level == 1){
        return model.name;
    }else if(level == 2){
        return model.name;
    }else{
        return @"";
    }
}



#pragma mark - MultiTablesViewDataSource
#pragma mark Levels

- (NSInteger)numberOfLevelsInMultiTablesView:(MultiTablesView *)multiTablesView {
	return 3;
}

#pragma mark Sections Headers & Footers

#pragma mark Sections
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView numberOfSectionsAtLevel:(NSInteger)level {
    //    NSLog(@"level %d count %d", level, [self.pickerDataSource[level] count]);
    return 1;
}

#pragma mark Rows

- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level numberOfRowsInSection:(NSInteger)section {
    NSArray *dict = self.pickerDataSource[level];
    
    return [dict count];
}
- (UITableViewCell *)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"ModelPickerCell";
    
    UITableViewCell *cell = [multiTablesView dequeueReusableCellForLevel:level withIdentifier:CellIdentifier];
    
    if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
    NSArray *dict = self.pickerDataSource[level];
    AddressModel *theModel = [dict objectAtIndex:indexPath.row];
    NSString *celltitle = [self makePickerStringWithModel:theModel andLevel:level];
    
	[cell.textLabel setText:celltitle];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

#pragma mark Sections Headers & Footers
- (CGFloat)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}
- (CGFloat)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

#pragma mark - MultiTablesViewDelegate
#pragma mark Levels
- (void)multiTablesView:(MultiTablesView *)multiTablesView levelDidChange:(NSInteger)level {
	if (multiTablesView.currentTableViewIndex == level) {
		[multiTablesView.currentTableView deselectRowAtIndexPath:[multiTablesView.currentTableView indexPathForSelectedRow] animated:YES];
        
	}
}
#pragma mark Rows
- (void)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor = [UIColor grayColor];
    
}

- (void)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (multiTablesView.currentTableViewIndex == level) {
        //        UITableViewCell *cell = [multiTablesView.currentTableView cellForRowAtIndexPath:indexPath];
        //        cell.textLabel.textColor = [UIColor redColor];
    }
    
    NSArray *dict = self.pickerDataSource[level];
    AddressModel *theModel = [dict objectAtIndex:indexPath.row];
    if (level == 0) {
        self.pickedModel.provinceCode = theModel.code;
        self.pickedModel.provinceName = theModel.name;
    }else if (level == 1){
        self.pickedModel.cityCode = theModel.code;
        self.pickedModel.cityName = theModel.name;
    }else{
        self.pickedModel.districtCode = theModel.code;
        self.pickedModel.districtName = theModel.name;
    }
    self.pickedModel.name = theModel.name;
    
    // 如果用作筛选 那么选到第2级
    if (self.showNoLimitButton) {
        if (self.showNoLimitButton && indexPath.section == 0 && indexPath.row == 0) {
            [self getTheNewestLevelId];
        }else{
            if (level == 0) {
                [self getTheNewestLevelId];
            }else{
                [self dataSourceWithLevel:level+1];
            }
        }
    }
    // 如果用作添加 那么选到第3级
    else{
        [self dataSourceWithLevel:level+1];

        if (level == 2) {
            [self getTheNewestLevelId];
        }
    }
    
}

- (void)getTheNewestLevelId
{
    [self.passDelegate passSignalValue:SIGNAL_PICK_AREA_MODEL andData:self.pickedModel];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

/////////////////////////////////////////////////////////
#pragma mark - 下一步显示
/////////////////////////////////////////////////////////



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showDoneButton
{
    self.showNoLimitButton = YES;
    [self.multiTableView setFrame:CGRectMake(0, IOS7_CONTENT_OFFSET_Y, TOTAL_WIDTH, TOTAL_HEIGHT-IOS7_CONTENT_OFFSET_Y-TABBAR_HEIGHT)];
    
    CGFloat buttonHeight;
    if (OSVersionIsAtLeastiOS7()) {
        buttonHeight = H_40;
    }else{
        buttonHeight = H_100;
    }
    
    self.sendButton = [[FAIconButton alloc]initWithFrame:CGRectMake(0, TOTAL_HEIGHT - buttonHeight, TOTAL_WIDTH, H_40)];
    [self.sendButton setIconString:ICON_CHECK];
    [self.sendButton setTitle:T(@"完成") forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(getTheNewestLevelId) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton changeGreenLightStyle];
    
    [self.view addSubview:self.sendButton];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
