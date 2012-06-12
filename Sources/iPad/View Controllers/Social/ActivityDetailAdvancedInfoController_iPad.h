//
//  ActivityDetailAdvancedInfoController_iPad.h
//  eXo Platform
//
//  Created by exoplatform on 6/7/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMTabView.h"

@class SocialActivity;
@class ActivityLikersViewController;
@class EmptyView;

typedef enum {
    ActivityAdvancedInfoCellTabComment = 0,
    ActivityAdvancedInfoCellTabLike = 1
} ActivityAdvancedInfoCellTab;

@interface ActivityDetailAdvancedInfoController_iPad : UIViewController <JMTabViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) JMTabView *tabView;
@property (nonatomic, retain) UITableView *infoView;
@property (nonatomic, retain) SocialActivity *socialActivity;
@property (nonatomic, retain) ActivityLikersViewController *likersViewController;
@property (nonatomic, retain) EmptyView *emptyView;
@property (nonatomic, retain) UIButton *commentButton;
@property (nonatomic, retain) UIView *infoContainer;

// this method is used to update value for subviews
- (void)updateSubViews;
- (void)updateTabLabels;
- (void)selectTab:(ActivityAdvancedInfoCellTab)selectedTab;
- (void)jumpToLastCommentIfExist;


@end
