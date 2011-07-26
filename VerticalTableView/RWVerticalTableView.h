//
//  RWVerticalTableView.h
//  VerticalTableView
//
//  Created by Ryan Wang on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTableViewCell.h"

@protocol RWVerticalTableViewDelegate;
@protocol RWVerticalTableViewDataSource;

@interface RWVerticalTableView : UIScrollView {
    NSMutableDictionary        *_reusableTableCells;
    NSMutableArray             *_visibleCells;
    
    CGRect                      _visibleBounds;
    NSRange                     _visibleRows;
    
    id <RWVerticalTableViewDataSource> _dataSource;
}

@property(nonatomic,assign)   id <RWVerticalTableViewDataSource> dataSource;
@property(nonatomic,assign)   id <RWVerticalTableViewDelegate,UIScrollViewDelegate>   delegate;


@end

@protocol RWVerticalTableViewDelegate <NSObject>

- (CGFloat)tableView:(RWVerticalTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol RWVerticalTableViewDataSource <NSObject>

- (NSInteger)numberOfSectionsInTableView:(RWVerticalTableView *)tableView;
- (NSInteger)verticalTableView:(RWVerticalTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (RWTableViewCell *)verticalTableView:(RWVerticalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
