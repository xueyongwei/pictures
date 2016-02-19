//
//  ViewController.m
//  pictures
//
//  Created by 薛永伟 on 16/2/18.
//  Copyright © 2016年 薛永伟. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "CoreRefreshEntry.h"

#import "PictureCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_keys;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController
#pragma mark  刷新控件准备
-(void)refreshWidgetPrepare{
    
    //添加顶部刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    
    //添加底部刷新
    [self.tableView addFooterWithTarget:self action:@selector(foorterRefresh)];
}
-(void)headerRefresh
{
    [self prepareData];
}
-(void)foorterRefresh
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _keys = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    
    self.tableView.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.pagingEnabled = YES;
    [self prepareData];

}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)prepareData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:@"http://api.huaban.com/favorite/beauty?limit=40" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
        NSDictionary *rspDic = responseObject;
        NSArray *arr = rspDic[@"pins"];
        for (NSDictionary *dic in arr) {
            NSDictionary *file = dic[@"file"];
            NSString *s = [NSString stringWithFormat:@"http://img.hb.aicdn.com/%@",file[@"key"]];
            [_keys addObject:s];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
-(void)printLink
{
    for (NSString *str in _keys) {
        NSLog(@"%@",str);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _keys.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PictureCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI/2);
    NSLog(@"%@",_keys[indexPath.row]);
    [cell.imgView setImageWithURL:[NSURL URLWithString:_keys[indexPath.row]]placeholderImage:nil];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.width;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
