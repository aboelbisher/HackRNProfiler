//
//  HackProfiler.m
//  HackRNProfiler
//
//  Created by Muhammad Abed El Razek on 25/03/2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "HackProfiler.h"

@import Darwin;

typedef struct {
  const char *key;
  int key_len;
  const char *value;
  int value_len;
} systrace_arg_t;

typedef struct {
  char *(*start)(void);
  void (*stop)(void);
  
  void (*begin_section)(uint64_t tag, const char *name, size_t numArgs, systrace_arg_t *args);
  void (*end_section)(uint64_t tag, size_t numArgs, systrace_arg_t *args);
  
  void (*begin_async_section)(uint64_t tag, const char *name, int cookie, size_t numArgs, systrace_arg_t *args);
  void (*end_async_section)(uint64_t tag, const char *name, int cookie, size_t numArgs, systrace_arg_t *args);
  
  void (*instant_section)(uint64_t tag, const char *name, char scope);
  
  void (*begin_async_flow)(uint64_t tag, const char *name, int cookie);
  void (*end_async_flow)(uint64_t tag, const char *name, int cookie);
} RCTProfileCallbacks;


char* profileStart()
{
  NSLog(@"profile start");
  return 0;
}

void profileStop()
{
  NSLog(@"profile stop");
}

void profileBeginSection(__unused uint64_t tag, const char *name, size_t numArgs, systrace_arg_t *args)
{
  NSLog(@"profileBeginSection");
}

void profileEndSection(__unused uint64_t tag, __unused size_t numArgs, __unused systrace_arg_t *args)
{
  NSLog(@"profileEndSection");

}

void profileBeginAsyncSection(uint64_t tag, const char *name, int cookie, size_t numArgs, systrace_arg_t *args)
{
  NSLog(@"profileBeginAsyncSection");

}

void profileEndAsyncSection(uint64_t tag, const char *name, int cookie, size_t numArgs, systrace_arg_t *args)
{
  NSLog(@"profileEndAsyncSection");
}

void profileInstantSection(uint64_t tag, const char *name, char scope)
{
  NSLog(@"profileInstantSection");

}

void profileBeginAsyncFlow(uint64_t tag, const char *name, int cookie)
{
  NSLog(@"profileBeginAsyncFlow");

}

void profileEndAsyncFlow(uint64_t tag, const char *name, int cookie)
{
  NSLog(@"profileEndAsyncFlow");

}


RCTProfileCallbacks profilerHackedCallbacks = {
  profileStart,
  profileStop,
  profileBeginSection,
  profileEndSection,
  profileBeginAsyncSection,
  profileEndAsyncSection,
  profileInstantSection,
  profileBeginAsyncFlow,
  profileEndAsyncFlow
};



void startListening()
{
  void (*registerCallbacks)(RCTProfileCallbacks *) = dlsym(RTLD_DEFAULT, "RCTProfileRegisterCallbacks");
  if(registerCallbacks != NULL)
  {
    registerCallbacks(&profilerHackedCallbacks);
  }

}
