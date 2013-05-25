//
//  MAListViewController.h
//  AllTheSingleLadies
//
//  Created by Nicholas Spencer on 5/17/13.
//  Copyright (c) 2013 Nicholas Spencer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *detailView;
@property (nonatomic,strong) IBOutlet UITableView *listView;

@end
