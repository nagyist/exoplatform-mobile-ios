//
//  ActivityForumTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"


@interface ActivityForumTableViewCell : ActivityBasicTableViewCell {

    
    RTLabel*                       _lbMessage;
    RTLabel*                      _htmlName;
    RTLabel*                      _lbTitle;
    
}
@property (retain, nonatomic) RTLabel* lbTitle;
@property (retain, nonatomic) RTLabel* lbMessage;
@property (retain, nonatomic) RTLabel* htmlName;


@end
