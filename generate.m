// See https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/Quicklook_Programming_Guide

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

#include "internal.h"

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI,
                                 CFDictionaryRef options, CGSize maxSize) {

  struct GetMKAThumb_return ret = GetMKAThumb((char *)[[((NSURL *)url) path] cStringUsingEncoding:NSUTF8StringEncoding], maxSize.width, maxSize.height);
  int err = ret.r0;
  UInt8* coverData = (UInt8*) ret.r1;
  CFIndex coverLen = ret.r2;

  if (err != 0 || coverData == NULL) {
    return noErr;
  }
  CFDataRef cover = CFDataCreate(kCFAllocatorDefault, coverData, coverLen);
  free(coverData);
  /* NSDictionary *props = [NSDictionary dictionaryWithObject:@"public.jpeg" forKey:(__bridge NSString *)kCGImageSourceTypeIdentifierHint]; */
  QLThumbnailRequestSetImageWithData(thumbnail, cover, NULL);
  CFRelease(cover);
  return noErr;
}

void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail) {}

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options) {
  // Not implemented right now. Fallback seems to work.
  return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview) {}
