//
//  ActivityAnswerTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"

@interface ActivityAnswerTableViewCell : ActivityBasicTableViewCell
{
    RTLabel*                      _lbMessage;
    RTLabel*                      _htmlName;
    RTLabel*                      _htmlTitle;
}

@property (retain, nonatomic) RTLabel* lbMessage;
@property (retain, nonatomic) RTLabel* htmlName;
@property (retain, nonatomic) RTLabel* htmlTitle;
@end
