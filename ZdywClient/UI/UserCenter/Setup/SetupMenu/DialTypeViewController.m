//
//  DialTypeViewController.m
//  ZdywClient
//
//  Created by ddm on 6/21/14.
//  Copyright (c) 2014 Guoling. All rights reserved.
//

#import "DialTypeViewController.h"
#import "MoreSectionNode.h"
#import "MoreRowNode.h"

#define  kDialTypeTableViewCellHeight   60

@interface DialTypeViewController ()

@property (nonatomic, strong) NSMutableArray *dialModeTypeArray;

@end

@implementation DialTypeViewController

#pragma mark - lifeCycle

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"拨打方式设置";
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self buildDialModeTypeDataModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrivateMethod

- (void)buildDialModeTypeDataModel{
    _dialModeTypeArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //first section
    MoreSectionNode *sectionNode = [[MoreSectionNode alloc] init];
    sectionNode.title = @"";
    
    NSString *directFee = [ZdywUtils getLocalStringDataValue:kDialModelDirectFee];
    if (0 == [directFee length])
    {
        directFee = @"0.1";
    }
    NSString *directRate = [ZdywUtils getLocalStringDataValue:kDialModelDirectRate];
    if (0 == [directRate length])
    {
        directRate = @"4K";
    }
    NSString *callBackFee = [ZdywUtils getLocalStringDataValue:kDialModelCallBackFee];
    if (0 == [callBackFee length])
    {
        callBackFee = @"0.15";
    }
    NSString *callBackRate = [ZdywUtils getLocalStringDataValue:kDialModelCallBackRate];
    if (0 == [callBackRate length])
    {
        callBackRate = @"1K";
    }
    MoreRowNode *rowNode = [[MoreRowNode alloc] init];
    sectionNode.title = @"";
    //智能拨打
    rowNode = [[MoreRowNode alloc] init];
    rowNode.imageName = @"";
    rowNode.mainTitle = @"智能拨打";
    rowNode.subTitle = @"在拨打时，系统根据网络情况自动为您匹配最佳的拨打方式，省心便捷";
    [sectionNode.child addObject:rowNode];
    [_dialModeTypeArray addObject:sectionNode];
    
    //second section
    sectionNode = [[MoreSectionNode alloc] init];
    sectionNode.title = @"";
    
    //默认直拨
    rowNode = [[MoreRowNode alloc] init];
    rowNode.imageName = @"";
    rowNode.mainTitle = @"默认直拨";
    rowNode.subTitle =  @"当网络信号不良时，推荐使用回拨";
    [sectionNode.child addObject:rowNode];
//    [_dialModeTypeArray addObject:sectionNode];
    
    //third section
    sectionNode = [[MoreSectionNode alloc] init];
    rowNode.imageName = @"";
    rowNode.mainTitle = @"默认回拨";
    rowNode.subTitle = @"回拨对网络要求不高，当您网络信号不良时，推荐使用回拨方式";
    [sectionNode.child addObject:rowNode];
    [_dialModeTypeArray addObject:sectionNode];
    
    
    //fourth section
    sectionNode = [[MoreSectionNode alloc] init];
    sectionNode.title = @"";
    
    //手动拨打
    rowNode = [[MoreRowNode alloc] init];
    rowNode.imageName = @"";
    rowNode.mainTitle = @"手动选择";
    rowNode.subTitle = @"手动选择下，每次呼叫时，系统会让您选择拨打方式，可以根据需要自主选择";
    [sectionNode.child addObject:rowNode];
    [_dialModeTypeArray addObject:sectionNode];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dialModeTypeArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_dialModeTypeArray objectAtIndex:section] child] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] ;
    if(indexPath.section == 0)
    {
        UILabel *subLbl = [[UILabel alloc] initWithFrame:CGRectMake(87, 5, 100, 20)];
        [subLbl setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:subLbl];
        subLbl.text = @"(推荐)";
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MoreRowNode *node = [[[_dialModeTypeArray objectAtIndex:indexPath.section] child] objectAtIndex:indexPath.row];
    int dialModeType = [[ZdywUtils getLocalIdDataValue:kDialModeType] intValue];
    NSString *imgName = @"more_dialmode_noselect_cell.png";
    if (indexPath.section == dialModeType)
    {
        imgName = @"more_dialmode_select_cell.png";
    }
    else
    {
        imgName = @"more_dialmode_noselect_cell.png";
    }
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    accessoryView.frame = CGRectMake(0, 0, 28, 28);
    accessoryView.backgroundColor = [UIColor clearColor];
    cell.accessoryView = accessoryView;
    accessoryView = nil;
    cell.textLabel.text = node.mainTitle;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.text = node.subTitle;
    return cell;
}

- (void) tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
    int dialModeType = [[ZdywUtils getLocalIdDataValue:kDialModeType] intValue];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:dialModeType];
    if([indexPath section] != [lastIndexPath section])
    {
        UITableViewCell *newCell = [_tableView cellForRowAtIndexPath:indexPath];
        UIImageView *view = (UIImageView*)newCell.accessoryView;
        [view setImage:[UIImage imageNamed:@"more_dialmode_select_cell.png"]];
        [ZdywUtils setLocalIdDataValue:[NSNumber numberWithInt:indexPath.section] key:kDialModeType];
        UITableViewCell *oldCell = [_tableView cellForRowAtIndexPath:lastIndexPath];
        UIImageView *view2 = (UIImageView*)oldCell.accessoryView;
        [view2 setImage:[UIImage imageNamed:@"more_dialmode_noselect_cell.png"]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDialTypeTableViewCellHeight;
}

@end
