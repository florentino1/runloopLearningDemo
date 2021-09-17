//
//  main.c
//  readTest
//
//  Created by 莫玄 on 2021/7/10.
//

#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#define MAXLINE 20

int cmp(const void* a,const void*b)
{
    int *i=*(int **)a;
    int *j=*(int **)b;
    return j[0]-i[0];//降序排列
}
char ** findRelativeRanks(int* score, int scoreSize, int* returnSize){
    char **res=(char **)calloc(scoreSize,sizeof(char *));
    int **ans=(int **)calloc(scoreSize ,sizeof(int *));
    *returnSize=0;
    for(int i=0;i<scoreSize;i++)
    {
        ans[i]=(int *)calloc(2,sizeof(int ));
        ans[i][0]=score[i];
        ans[i][1]=i;
    }
    qsort(ans,scoreSize,sizeof(int *),cmp);
    for(int i=0;i<scoreSize;i++)
    {
        int index=ans[i][1];
        res[index]=(char *)calloc(20,sizeof(char));
        if(i==0)
            res[index]="Gold Medal";
        else if(i==1)
            res[index]="Silver Medal";
        else if(i==2)
            res[index]="Bronze Medal";
        else
            {
                char str[20];
                sprintf(str,"%d",i+1);
                strcpy(res[index],str);
            }
       (*returnSize)++;
    }
    return res;
}
int main(int argc, const char * argv[]) {
    int score[5]={5,4,3,2,1};
    int returnSize;
    char **res=findRelativeRanks(score, 5, &returnSize);
    int i=0;
    while (i<returnSize) {
        printf("%s ",res[i]);
        i++;
    }
    return 0;
}
