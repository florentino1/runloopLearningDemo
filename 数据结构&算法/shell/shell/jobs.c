//
//  jobs.c
//  shell
//
//  Created by 莫玄 on 2021/9/4.
//

#include "jobs.h"
#include <string.h>
#include <stdlib.h>
struct jobLink{
    int *array;
    int p;
};
typedef struct jobLink jobLink;
jobLink *jobArray=NULL;
void initJobs(void)
{
    jobLink *job=malloc(sizeof(jobLink));
    job->p=0;
    job->array=(int *)calloc(1000, sizeof(int));
    jobArray=job;
}
void addjob(int pid)
{
    int point=jobArray->p;
    jobArray->array[point]=pid;
    (jobArray->p)++;
}
void deljob(int pid)
{
    int point=jobArray->p;
    if(jobArray->p==0)
    {
        printf("error: jobsArray has no job indeed\n");
        exit(9);
    }
    jobArray->array[point-1]=0;
    (jobArray->p)--;
}
int jobcount(void)
{
    return jobArray->p-1;
}
