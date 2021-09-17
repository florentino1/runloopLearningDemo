//
//  jobs.h
//  shell
//
//  Created by 莫玄 on 2021/9/4.
//

#ifndef jobs_h
#define jobs_h

#include <stdio.h>
void initJobs(void);
void deljob(int pid);
void addjob(int pid);
int jobcount(void);

#endif /* jobs_h */
