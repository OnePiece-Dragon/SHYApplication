//
//  UIControl+SHYTargetAction.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/18.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "UIControl+SHYTargetAction.h"

@interface UIControl()

@property (nonatomic, assign) NSTimeInterval action_ignoreEvent;

@end

@implementation UIControl (SHYTargetAction)

+ (void)load {
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(__action_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}

- (instancetype)init {
    if ([super init]) {
        self.action_acceptEventInterval = 1.f;
    }
    return self;
}

- (NSTimeInterval)action_acceptEventInterval {
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}
- (void)setAction_acceptEventInterval:(NSTimeInterval)action_acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(action_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)action_ignoreEvent {
    return [objc_getAssociatedObject(self, UIControl_ignoreEventTime) doubleValue];
}
- (void)setAction_ignoreEvent:(NSTimeInterval)action_ignoreEvent {
    objc_setAssociatedObject(self, UIControl_ignoreEventTime, @(action_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)__action_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.action_ignoreEvent >= self.action_acceptEventInterval);
    if (self.action_acceptEventInterval > 0) {
        self.action_ignoreEvent = NSDate.date.timeIntervalSince1970;
    }
    if (needSendAction) {
        [self __action_sendAction:action to:target forEvent:event];
    }
}

@end
