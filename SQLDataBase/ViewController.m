//
//  ViewController.m
//  SQLDataBase
//
//  Created by Mengying Xu on 14-10-21.
//  Copyright (c) 2014年 Crystal Xu. All rights reserved.
//

#import "ViewController.h"
#import "DBOperation.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;

@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *BdataArr;

@end

@implementation ViewController
- (id)init
{
    self = [super init];
    if(self)
    {
        if(!_dataArr)
            _dataArr = [[NSMutableArray alloc] init];
        if(!_BdataArr)
            _BdataArr = [[NSMutableArray alloc] init];

    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.leftBtn.frame =CGRectMake(0, 20, 160, 30);
    self.rightBtn.frame =CGRectMake(160, 20, 160, 30);
    self.tableView.frame =CGRectMake(0, 50, 320, self.view.frame.size.height-50);

    self.leftBtn.selected = YES;
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    
    [self.view addSubview:self.tableView];
    
    [self writeToDB];
    [self getAllData];
    
}
- (UITableView*)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}

- (UIButton*)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _leftBtn.selected = YES;
        
        [self setBtnPropetry:_leftBtn];
        
        [_leftBtn setTitle:@"A" forState:UIControlStateNormal];
        
        _leftBtn.tag = 100;
    }
    
    return _leftBtn;
}
- (UIButton*)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self setBtnPropetry:_rightBtn];
        
        [_rightBtn setTitle:@"B" forState:UIControlStateNormal];
        
        _rightBtn.tag = 200;
        
    }
    
    return _rightBtn;
}
- (void)setBtnPropetry:(UIButton*)btn
{
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"hsptl"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if(btn.selected == YES)
    {
        btn.backgroundColor = [UIColor orangeColor];
    }
    else
    {
        btn.backgroundColor = [UIColor clearColor];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectBtnAction:(UIButton*)sender
{
    if(sender.selected == YES)
    {
        return;
    }
    sender.selected = !sender.isSelected;
    
    
    if(sender.tag == 100)
    {
        self.leftBtn.selected = YES;
        self.rightBtn.selected = NO;
        self.leftBtn.backgroundColor = [UIColor orangeColor];
        self.rightBtn.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.rightBtn.selected = YES;
        self.leftBtn.selected = NO;
        self.rightBtn.backgroundColor = [UIColor orangeColor];
        self.leftBtn.backgroundColor = [UIColor whiteColor];
    }
    [self writeToDB];
    [self getAllData];

    [self.tableView reloadData];
}

- (void)writeToDB
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(queue, ^{
        if(self.leftBtn.selected == YES)
        {
            for(int i=1; i <= 200; i++)
            {
                DBOperation *db = [[DBOperation alloc] init];
                
                [db writeToDB:@"A" Withkey:i WithValue:[NSString stringWithFormat:@"ACell_%i",i]];
            }
            
        }
        else
        {
            for(int i=200; i <= 350; i++)
            {
                DBOperation *db = [[DBOperation alloc] init];
                
                [db writeToDB:@"B" Withkey:i WithValue:[NSString stringWithFormat:@"BCell_%i",i]];
            }
            
            
        }

    });
    
}


- (void)getAllData
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        if(self.leftBtn.selected == YES)
        {
            DBOperation *db = [[DBOperation alloc] init];
            
            self.dataArr = [db getDataFromDB:@"A" Withkey:0 WithValue:@"0"];
        }
        else
        {
            DBOperation *db = [[DBOperation alloc] init];
            
            self.BdataArr = [db getDataFromDB:@"B" Withkey:0 WithValue:@"0"];
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];

        });
        
    });
    
}

#pragma mark -UITableView Delegate And DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.leftBtn.selected == YES)
    {
        return [_dataArr count];

    }
    else
    {
        return [_BdataArr count];

    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
    }
    if(self.leftBtn.selected == YES)
    {
        cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
        
    }
    else
    {
       
        cell.textLabel.text = [self.BdataArr objectAtIndex:indexPath.row];
        
    }
    
   

    return cell;
}

@end
