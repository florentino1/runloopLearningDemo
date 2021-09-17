//
//  main.c
//  1859将句子排序
//
//  Created by 莫玄 on 2021/8/6.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char * sortSentence(char * s){
    int length=strlen(s);
    int j=0;//用于保存上一个词条的长度+空格
    char **arr=(char **)calloc(9,sizeof(char *));
    int num=0;
    for(int i=0;i<=length;i++)
    {
        if(s[i]==' ' || s[i]=='\0')
        {
            int index=s[i-1]-'1';//词末尾的数字-1 即为在arr中应该处于的序号;
            arr[index]=(char *)calloc(201,sizeof(char));
            int n=i-j;//本词的长度,不包含末尾的''；
            memcpy(arr[index],s+j,n-1);//从s+j的位置起复制n-1个字符
            arr[index][n-1]=' ';//将词的末尾预留一个空格
            arr[index][n]='\0';//将该数组转化为字符串数组；
            j=i+1;
            num++;
        }
    }
    char *res=(char *)calloc(201,sizeof(char));
    res[0]='\0';
    for(int i=0;i<num;i++)
    {
        strcat(res,arr[i]);
    }
    int resl=strlen(res);
    res[resl-1]='\0';//去除末尾多预留的一个空格
    return res;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    char s[20]="Myself2 Me1 I4 and3";
    sortSentence(s);
    return 0;
}
