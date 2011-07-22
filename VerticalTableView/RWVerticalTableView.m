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
        self.delaysContentTouches = NO;
        
        _reusableTableCells = [[NSMutableDictionary alloc] init];
        _visibleCells = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setDataSource:(id<RWVerticalTableViewDataSource>)aDataSource {
    dataSource = aDataSource;
    [self configureUIFirstTime];
}

- (void)setDelegate:(id<RWVerticalTableViewDelegate>)aDelegate {
    delegate = aDelegate;
    [self configureUIFirstTime];
}

//- (void)drawRect:(CGRect)rect {
//    NSLog(@"%s",_cmd);
//
//}

- (void)configureUIFirstTime {
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
        
        self.contentSize = CGSizeMake(cellOffset, self.frame.size.height);

        
    }    
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
        
        self.contentSize = CGSizeMake(cellOffset, self.frame.size.height);
        
        
    }    
}



//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s",_cmd);
//    UITouch *touch = [touches anyObject];
//
//}
//
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",_cmd);
    UITouch *touch = [touches anyObject];
    [self configureUIWhenMoved];
}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s",_cmd);
//    UITouch *touch = [touches anyObject];
//
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s",_cmd);
//    UITouch *touch = [touches anyObject];
//
//}

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
