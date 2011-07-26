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

@synthesize dataSource = _dataSource;
@synthesize delegate = __delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.backgroundColor = [UIColor whiteColor];
        self.delaysContentTouches = YES;
        
        _reusableTableCells = [[NSMutableDictionary alloc] init];
        _visibleCells = [[NSMutableArray alloc] init];
        
        _visibleRows = NSMakeRange(0, 0);
    }
    
    return self;
}

//- (void)setDelegate:(id<UIScrollViewDelegate,RWVerticalTableViewDelegate>)aDelegate {
//    [super setDelegate:aDelegate];
//    __delegate = aDelegate;
//
//}
//
//- (void)setDataSource:(id<RWVerticalTableViewDataSource>)aDataSource {
//    _dataSource = aDataSource;
//    
//}

//- (void)calculateContentSize {
//    if (__delegate && _dataSource) {
//        NSInteger rows = [self.dataSource verticalTableView:self numberOfRowsInSection:0];
//
//    }
//}

- (void)layoutSubviews {
    
    _visibleBounds = CGRectMake(self.contentOffset.x, 0, self.frame.size.width, self.frame.size.height);

    if (self.delegate && self.dataSource) {
        NSInteger rows = [self.dataSource verticalTableView:self numberOfRowsInSection:0];

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
            // 如果cellFrame与_visibleBounds 没有交集 移出_visibleCells 添加到_reusableTableCells中
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
        
        self.contentSize = CGSizeMake(cellOffset, self.frame.size.height);
        
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    RWTableViewCell *cell = [_reusableTableCells objectForKey:identifier];
    if ([_visibleCells containsObject:cell]) {
        return nil;
    }
    return [_reusableTableCells objectForKey:identifier];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
}

- (void)dealloc {
    self.delegate = nil;
    self.dataSource = nil;
    [_reusableTableCells release];
    [_visibleCells release];
    [super dealloc];
}

@end
