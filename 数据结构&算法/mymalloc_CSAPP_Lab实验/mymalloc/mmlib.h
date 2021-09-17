//
//  mmlib.h
//  mymalloc
//
//  Created by 莫玄 on 2021/9/6.
//

#ifndef mmlib_h
#define mmlib_h

#include <stdio.h>

void mem_init(void);
void *mem_sbrk(int incr);
#endif /* mmlib_h */
