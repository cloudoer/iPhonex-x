//
//  iPhonex_x.m
//  iPhonex,x
//
//  Created by BlueCocoa on 14-7-27.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "iPhonex_x.h"
#import <objc/runtime.h>
#import <substrate.h>
#import <sys/sysctl.h>
#import <string.h>


static IMP originalUIDeviceImplementation = NULL;

@implementation iPhonex_x

+ (void)load{
    [super load];
    
    MSHookFunction(sysctlbyname, repl_sysctlbyname, &orig_sysctlbyname);
    
    Class originalUIDeviceClass = NSClassFromString(@"UIDevice");
    Method originalUIDeviceMethod = class_getInstanceMethod(originalUIDeviceClass, @selector(model));
    originalUIDeviceImplementation = method_getImplementation(originalUIDeviceMethod);
    Method replacementUIDeviceMethod = class_getInstanceMethod(NSClassFromString(@"iPhonex_x"), @selector(repl_model));
    method_exchangeImplementations(originalUIDeviceMethod, replacementUIDeviceMethod);
}

#pragma mark - MSHookFunction

static int (*orig_sysctlbyname)(const char *arg1, void * arg2, size_t * arg3, void * arg4, size_t arg5);
int repl_sysctlbyname(const char *arg1, void * arg2, size_t * arg3, void * arg4, size_t arg5);
int repl_sysctlbyname(const char *arg1, void * arg2, size_t * arg3, void * arg4, size_t arg5){
    NSLog(@"QQ Use sysctlbyname -> %s",arg1);
    if (strcmp(arg1, "hw.machine") == 0 && arg2 != NULL) {
        arg2 = "iPhone7,2";
        NSLog(@"Switch to iPhone7,2");
        return 0;
    }else if (strcmp(arg1, "hw.model") == 0 && arg2 != NULL){
        arg2 = "N63AP";
        NSLog(@"Switch to N63AP");
        return 0;
    }else return orig_sysctlbyname(arg1,arg2,arg3,arg4,arg5);
}

#pragma mark - objc runtime

- (NSString *)repl_model{
    NSLog(@"QQ Use UIDevice model");
    NSLog(@"Switch to iPhone Prototype");
    return @"iPhone 6s";
}


@end