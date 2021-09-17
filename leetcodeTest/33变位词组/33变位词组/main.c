//
//  main.c
//  33变位词组
//
//  Created by 莫玄 on 2021/8/14.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#define DEBUG
/*
 1、tmp作为辅助数组，存储将str中每个 子字符数组 按照字典序进行排序后的元素；
 2、res作为返回数组;如果returnSize==0，则将str[0]复制到res[0][0]中，且(*returnClomnSize)[0]++,(*returnSize)++;
 3、如果returnSize!=0，在tmp数组中从低到高寻找与与tmp[i]相同的子数组；
 3.1、如果存在这样的一个子数组tmp[index]与tmp[i]完全相同，则需要在返回数组res中寻找tmp[index]所对应的strs[index]在res的哪一个子数组中；
 3.2、如果不存在这样的子数组，则需要在res中新分配一个子数组res[*returnSize][0]用于储存tmp[i]，然后(*returnClomnSize)[*returnSize]++,(*returnSize)++;
 */
int cmp(const void*a,const void*b)
{
    return *(char *)a-*(char *)b;
}
char *** groupAnagrams(char ** strs, int strsSize, int* returnSize, int** returnColumnSizes){
    char **tmp=(char **)calloc(strsSize,sizeof(char *));//储存对str的各个子字符串排序的字符数组；
    for(int i=0;i<strsSize;i++)
    {
        char *string=strs[i];
        int length=strlen(string);
        tmp[i]=(char *)calloc(101,sizeof(char));
        memcpy(tmp[i],string,length);
        qsort(tmp[i],length,sizeof(char),cmp);
    }
#ifdef DEBUG
    printf("排序后的字符串：\n");
    for(int i=0;i<strsSize;i++)
    {
        printf("%s\n",tmp[i]);
    }
#endif
    char ***res=(char ***)calloc(strsSize,sizeof(char **));
    *returnSize=0;
    *returnColumnSizes=(int *)calloc(strsSize,sizeof(int));
    for(int i=0;i<strsSize;i++)
    {
        unsigned long length=strlen(tmp[i]);
        int n=(*returnColumnSizes)[*returnSize];
        res[*returnSize]=(char **)calloc(101,sizeof(char *));
        res[*returnSize][n]=(char *)calloc(101,sizeof(char));
        if(*returnSize==0)
        {
            memcpy(res[0][0],strs[0],length+1);
#ifdef DEBUG
            printf("res[%d][%d]:%s\n",0,0,res[0][0]);
#endif
            (*returnColumnSizes)[0]+=1;
            (*returnSize)++;
            continue;
        }
        int index=0;
        while(index<i)
        {
            int equl=strcmp(tmp[index],tmp[i]);
            if(equl==0)
            {
                int k;
                for(k=0;k<(*returnSize);k++)
                {
                    int ans=strcmp(res[k][0], strs[index]);
                    if(ans==0)
                        break;
                }
                int m=(*returnColumnSizes)[k];
                if(res[k][m]==NULL)
                    res[k][m]=(char *)calloc(101,sizeof(char));
                memcpy(res[k][m],strs[i],length+1);
#ifdef DEBUG
            printf("res[%d][%d]:%s\n",k,m,res[k][m]);
#endif
                (*returnColumnSizes)[k]++;
                break;
            }
            index++;
        }
        if(index==i)
        {
            (*returnColumnSizes)[*returnSize]=0;
            int m=(*returnColumnSizes)[*returnSize];
            if(res[*returnSize][m]==NULL)
                res[*returnSize][m]=(char *)calloc(101,sizeof(char));
            memcpy(res[*returnSize][0],strs[i],length+1);
#ifdef DEBUG
            printf("res[%d][%d]:%s\n",*returnSize,m,res[*returnSize][0]);
#endif
            (*returnColumnSizes)[*returnSize]++;
            (*returnSize)++;
        }

    }
    return res;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    char strs[6][10] = {"eat", "tea", "tan", "ate", "nat", "bat"};
    char **strs2=(char **)calloc(6,sizeof(char *));
    for(int i=0;i<6;i++)
    {
        char *s=strs[i];
        int lent=strlen(s);
        strs2[i]=(char *)calloc(101, sizeof(char));
        memcpy(strs2[i], s,lent+1);
    }
    char ***res;
    int returnSize=0;
    int **returnColumnSizes=(int **)calloc(1, sizeof(int *));
    res=groupAnagrams(strs2, 6, &returnSize, returnColumnSizes);
    printf("return ans is:\n");
    for(int i=0;i<returnSize;i++)
    {
        int n=(*returnColumnSizes)[i];
        for(int j=0;j<n;j++)
            printf("%s \n",res[i][j]);
    }
    return 0;
}
#undef DEBUG
