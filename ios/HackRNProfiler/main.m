/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>
@import ObjectiveC;
@import Darwin;
#import "fishhook.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppDelegate.h"

static void (*__orig_RCTBridge_setUp)(id self, SEL _cmd);
static void __hacked_RCTBridge_setUp(id self, SEL _cmd)
{
  __orig_RCTBridge_setUp(self, _cmd);
  void (*RCTProfileInit)(id) = (void*)dlsym(RTLD_DEFAULT, "RCTProfileInit");
  RCTProfileInit([self valueForKey:@"batchedBridge"]);
}

static JSObjectRef (*__origin_JSObjectMake)(JSContextRef ctx, JSClassRef jsClass, void* data);
static JSObjectRef __hacked_JSOBjectMake(JSContextRef ctx, JSClassRef jsClass, void* data)
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    JSContext* objcCtx = [JSContext contextWithJSGlobalContextRef:(JSGlobalContextRef)ctx];
    objcCtx[@"nativeTraceBeginSection"] = ^ (int tag, NSString* _name , id args)
    {
      NSLog(@"nativeTraceBeginSection called");
    };
    
    objcCtx[@"nativeTraceEndSection"] = ^ (int tag)
    {
      NSLog(@"nativeTraceEndSection called");
    };
    
    objcCtx[@"nativeTraceBeginAsyncSection"] = ^(int tag, NSString* name, int cookie)
    {
      NSLog(@"nativeTraceBeginAsyncSection called");
    };
    
    objcCtx[@"nativeTraceEndAsyncSection"] = ^(int tag, NSString* name, int cookie)
    {
      NSLog(@"nativeTraceEndAsyncSection called");
    };
    
    objcCtx[@"nativeTraceBeginLegacy"] = ^()
    {
      NSLog(@"nativeTraceBeginLegacy called");
    };
    
    objcCtx[@"nativeTraceEndLegacy"] = ^()
    {
      NSLog(@"nativeTraceEndLegacy called");
    };
  
  });
  return __origin_JSObjectMake(ctx, jsClass, data);
}

static void hackJSObjectMakeFunction()
{
  Class cls = NSClassFromString(@"RCTBridge");
  if(cls == nil) // no reat-native installed
  {
    return;
  }
  __origin_JSObjectMake = dlsym(RTLD_DEFAULT, "JSObjectMake");
  rebind_symbols((struct rebinding[]){
    {"JSObjectMake",
      __hacked_JSOBjectMake,
      NULL
    },
  }, 1);
  
  
  Method m = class_getInstanceMethod(cls, NSSelectorFromString(@"setUp"));
  __orig_RCTBridge_setUp = (void*)method_getImplementation(m);
  method_setImplementation(m, (IMP)__hacked_RCTBridge_setUp);
}

int main(int argc, char * argv[])
{
  hackJSObjectMakeFunction();
  @autoreleasepool {
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
