//
//  MAListViewController.m
//  AllTheSingleLadies
//
//  Created by Nicholas Spencer on 5/17/13.
//  Copyright (c) 2013 Nicholas Spencer. All rights reserved.
//

#import "MAListViewController.h"
#import "UIColor+MLPFlatColors.h"

@interface MAListViewController ()

@property (nonatomic,strong) NSMutableArray *data;

@end

@implementation MAListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.data = [NSMutableArray array];
        UIColor *prevColor = [UIColor randomFlatColor];
        for (NSInteger i = 0; i < 99; i++) {
            prevColor = [UIColor randomFlatColorBesides:prevColor];
            [self.data addObject:prevColor];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.detailView.rowHeight = self.detailView.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView!=self.listView) return;
    
    static NSInteger previousPage = 0;
    CGFloat cellHeight = self.listView.rowHeight;
    float fractionalPage = (scrollView.contentOffset.y-cellHeight) / cellHeight;
    fractionalPage = fractionalPage < 0.0f ? 0.0f : fractionalPage;
    NSInteger page = (int)floorf(fractionalPage);
    if (previousPage != page) {
        NSIndexPath *newPage = [NSIndexPath indexPathForRow:page inSection:0];
        [self.detailView scrollToRowAtIndexPath:newPage atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        previousPage = page;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView!=self.listView) return;
    
    CGFloat cellHeight = self.listView.rowHeight;
    float fractionalPage = (scrollView.contentOffset.y) / cellHeight;
    fractionalPage = fractionalPage < 0.0f ? 0.0f : fractionalPage;
    NSInteger page = (int)ceilf(fractionalPage);
    NSIndexPath *newPage = [NSIndexPath indexPathForRow:page inSection:0];
    [self.listView scrollToRowAtIndexPath:newPage atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView!=self.listView || decelerate) return;
    
    CGFloat cellHeight = self.listView.rowHeight;
    float fractionalPage = (scrollView.contentOffset.y) / cellHeight;
    fractionalPage = fractionalPage < 0.0f ? 0.0f : fractionalPage;
    NSInteger page = (int)ceilf(fractionalPage);
    if (page>self.data.count-1) page=self.data.count-1;
    NSIndexPath *newPage = [NSIndexPath indexPathForRow:page inSection:0];
    [self.listView scrollToRowAtIndexPath:newPage atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
 
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"RandomColorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    UIColor *currentColor = [self.data objectAtIndex:indexPath.row];
    cell.backgroundView.backgroundColor = currentColor;
    cell.backgroundColor = currentColor;
    cell.contentView.backgroundColor = currentColor;
    cell.textLabel.text = [NSString stringWithFormat:@"jibberish %d", indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView!=self.listView) return;
    
    NSIndexPath *indexPathBelowSelected = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    [self.listView scrollToRowAtIndexPath:indexPathBelowSelected atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.detailView scrollToRowAtIndexPath:indexPathBelowSelected atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
