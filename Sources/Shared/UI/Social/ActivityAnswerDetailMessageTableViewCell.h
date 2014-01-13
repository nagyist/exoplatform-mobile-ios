//
//  ActivityAnswerDetailMessageTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailMessageTableViewCell.h"


@interface ActivityAnswerDetailMessageTableViewCell : ActivityDetailMessageTableViewCell
{
    RTLabel*                      _htmlMessage;
    RTLabel*                      _htmlTitle;
    RTLabel*                      _htmlName;
    CGFloat width;
}
@property (retain, nonatomic) RTLabel* htmlMessage;
@property (retain, nonatomic) RTLabel* htmlTitle;
@property (retain, nonatomic) RTLabel* htmlName;
@end
