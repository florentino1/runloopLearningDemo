//
//  mm.h
//  mymalloc
//
//  Created by 莫玄 on 2021/9/6.
//

#ifndef mm_h
#define mm_h

#include <stdio.h>
//内存单元的模型结构，提供了可供外部调用的函数接口；
extern int mm_init(void);
extern void *mm_malloc(size_t size);
extern void mm_free(void *ptr);
#endif /* mm_h */
