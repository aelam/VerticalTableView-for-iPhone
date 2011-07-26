//
//  RWVerticalTableView.m
//  VerticalTableView
//
//  Created by Ryan Wang on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RWVerticalTableView.h"

@interface RWVerticalTableView (Private)

- (void)configureUI;

@end


@implementation RWVerticalTableView

@synthesize dataSource;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.backgroundColor = [UIColor whiteColor];
        self.alwaysBounceVertical = YES;
        
        _reusableTableCells = [[NSMutableDictionary alloc] init];
        _visibleCells = [[NSMutableArray alloc] init];
        
        _visibleRows = NSMakeRange(0, 0);
    }
    
    return self;
}

- (void)layoutSubviews {
    
    _visibleBounds = CGRectMake(self.contentOffset.x, 0, self.frame.size.width, self.frame.size.height);

    if (self.delegate && self.dataSource) {
        NSInteger rows = [self.dataSource verticalTableView:self numberOfRowsInSection:0];

        //CGFloat width = self.frame.size.width;
        CGFloat cellOffset = 0;
        
        for (int i = 0; i < rows; i++) {
            CGFloat cellWidth = [self.delegate tableView:self widthForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            CGRect cellFrame = CGRectMake(cellOffset,0, cellWidth, self.frame.size.height);
            
            
            // 如果cellFrame与_visibleBounds 有交集 
            if (CGRectIntersectsRect(cellFrame, _visibleBounds)) {
                
                // 查找当前应该显示cell的位置是否有cell
                // 如果有就continue
                // 如果没有就要创建一个然后add在superview上面
                RWTableViewCell *tempCell = nil;
                for(RWTableViewCell *cell in _visibleCells) {
                    if(CGRectEqualToRect(cell.frame, cellFrame)) {
                        tempCell = cell;
                        break;
                    }
                }
                if (tempCell == nil) {
                    RWTableViewCell *cell = [self.dataSource verticalTableView:self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    if(![_visibleCells containsObject:cell]) {
                        [_visibleCells addObject:cell];
                    } 
                    
                    if ([[_reusableTableCells objectForKey:cell.reuseIdentifier] isEqual:cell]) {
                        [_reusableTableCells removeObjectForKey:cell.reuseIdentifier];
                    }
                    cell.frame = cellFrame;
                    [self addSubview:cell];
                }
            }
            else {
                RWTableViewCell *tempCell = nil;
                for(RWTableViewCell *cell in _visibleCells) {
                    if(CGRectEqualToRect(cell.frame, cellFrame)) {
                        tempCell = cell;
                        break;
                    }
                } 
                if (tempCell) {
                    [_reusableTableCells setObject:tempCell forKey:tempCell.reuseIdentifier];   
                    [_visibleCells removeObject:tempCell];
                }
            }
            
            
            cellOffset += cellWidth;                
        }
        
        self.contentSize = CGSizeMake(cellOffset, self.frame.size.height - 60);
        
    }
    NIF_TRACE(@"visible Cells : %@", _visibleCells);
}

- (void)configureUIWhenMoved {
    if (self.delegate && self.dataSource) {
        NSInteger rows = [self.dataSource verticalTableView:self numberOfRowsInSection:0];
        
        CGFloat width = self.frame.size.width;
        CGFloat cellOffset = self.contentOffset.x;
        for(int i = 0; i < rows;i++) {
            
            CGFloat cellWidth = [self.delegate tableView:self widthForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            if (cellOffset < width) {
                
                CGRect cellFrame = CGRectMake(cellOffset,0, cellWidth, self.frame.size.height);
                
                RWTableViewCell *cell = [self.dataSource verticalTableView:self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if(![_visibleCells containsObject:cell]) {
                    [_visibleCells addObject:cell];
                } 
                
                cell.frame = cellFrame;
                
                
                [_reusableTableCells setObject:cell forKey:cell.reuseIdentifier];
                
                [self addSubview:cell];                
            }
            cellOffset += cellWidth;                
            
        }
        
        self.contentSize = CGSizeMake(cellOffset, self.frame.size.height - 40);
        
        
    }    
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    RWTableViewCell *cell = [_reusableTableCells objectForKey:identifier];
    if ([_visibleCells containsObject:cell]) {
        return nil;
    }
    return [_reusableTableCells objectForKey:identifier];
}

- (void)dealloc {
    self.delegate = nil;
    self.dataSource = nil;
    [_reusableTableCells release];
    [_visibleCells release];
    [super dealloc];
}

@end
