//
//  showBinaryStirng.c
//  echoWebServer
//
//  Created by 莫玄 on 2021/8/12.
//

#include <stdio.h>
#include <limits.h>//提供CAHR_BIT宏 表示每个字节的位数量
#include <string.h>
#include <stdlib.h>

void showBinaryString(int n)
{
    int tmp=n;
    int size=sizeof(int)*CHAR_BIT;
    char *binaryString=(char *)calloc(size+1, sizeof(char));
    //获得int型数的二进制字符串
    for(int i=size-1;i>=0;i--)
    {
        binaryString[i]=(0x0001 & n) +'0';//要把数字转化为字符才能保存在char *中；
        n=n>>1;
    }
    binaryString[size]='\0';

    //输出该二进制字符串
    int i=0;
    fprintf(stdout, "%d的二进制表示是：",tmp);
    while (binaryString[i])//binaryString 不是一个空字符
    {
        fprintf(stdout,"%c",binaryString[i++]);
        if(i%4==0 && binaryString[i]) //四字节对齐
            fprintf(stdout, " ");
    }
    putchar('\n');
}
int main(int argc,char ** argv)
{
    int n;
    fprintf(stdout, "请输入int型数字：\n");
    while(scanf("%d",&n)==1)
    {
        showBinaryString(n);
        fprintf(stdout, "请输入int型数字：\n");
    }
    exit(0);
}
