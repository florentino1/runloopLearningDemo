//
//  main.m
//  187重复DNA序列
//
//  Created by 莫玄 on 2021/10/8.
//

#import <Foundation/Foundation.h>
#import "string.h"
#import <strhash.h>


char ** findRepeatedDnaSequences(char * s, int* returnSize){
    int length=strlen(s);
    *returnSize=0;
    if(length<=10)
        return NULL;
    char **res=(char **)calloc(length,sizeof(char *));   //结果字符串数组
    char *mode=(char *)calloc(11,sizeof(char));         //模式串数组
    int *hash=(int *)malloc(length*sizeof(int));
    memset(hash,-1,length);
    char *pos=s;
    char *pos1;
    for(int i=0;i<length-10;i++)
    {
        strncpy(mode,pos,10);
        pos+=1;
        pos1=pos;
        while(pos1)
        {
            char *p=strstr(pos1,mode);
            if(p)
            {
                int index=p-s;
                if(hash[index]>=1)
                    break;
                res[*returnSize]=(char *)calloc(11,sizeof(char));
                strncpy(res[*returnSize],mode,10);
                (*returnSize)++;
                hash[index]=1;
            }
            else
                break;
            pos1++;
        }
    }
    return res;
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        int* returnSize=malloc(1*sizeof(int));
        char *s="AAAAAAAAAAAAAAAA";
        char **res=findRepeatedDnaSequences(s, returnSize);
        for(int i=0;i<(*returnSize);i++)
            NSLog(@"%s ",res[i]);
    }
    return 0;
}
