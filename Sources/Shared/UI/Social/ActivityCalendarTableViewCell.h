//
//  ActivityCalendarTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"
@interface ActivityCalendarTableViewCell : ActivityBasicTableViewCell
{
    RTLabel*                      _lbMessage;
    RTLabel*                      _htmlName;
    RTLabel*                      _htmlTitle;
    
}
@property (retain, nonatomic) RTLabel* htmlTitle;
@property (retain, nonatomic) RTLabel* lbMessage;
@property (retain, nonatomic) RTLabel* htmlName;

@end
