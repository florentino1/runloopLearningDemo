//
//  main.c
//  166分数到小数
//
//  Created by 莫玄 on 2021/10/3.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// 判断输入两个数的正负号，以便决定在最终的输出中是否输出‘-’；
char *symboljust(int n,int d,char *res)
{
    if((n>=0 && d>0)|| (n<=0 && d<0))
        res=res+1;
    else
        res[0]='-';
    return res;
}

// 找到tmpString数组中重复的余数的位置，其于resString字符串的位置序号相同；
int finderepeat(long repeat,long index,long *arr)
{
    for(long i=index;arr[i]!=-1;i++)
    {
        if(repeat==arr[i])
            return i;
    }
    return -1;
}

// 对返回字符串的整数部分进行填充；
void fillString(long a,char *res)
{
    int *arr=calloc(10000, sizeof(int));
    int i=0;
    int d=10;
    while((a/d)!=0)
    {
        arr[i++]=a%d;
        a=a/d;
    }
    arr[i]=a;
    for(int j=1;i>=0;i--)
    {
        res[j]=arr[i]+'0';
        j++;
    }
    
}
char * fractionToDecimal(int numerator, int denominator){
// 为了防止最小的负数越界 先转化为long；
    long n=(long)numerator;
    long d=(long)denominator;
    char *resString=(char *)calloc(10003,sizeof(char ));        //需要进行返回的结果字符串

// 将输入的数字转化为绝对值进行计算；
    n=labs(n);
    d=labs(d);
    long a=n/d;                       //整数部分;
    fillString(a,resString);          //填充整数部分
    if(n%d==0)    //结果不存在小数部分时;
    {
        //需要判断正负;
        resString=symboljust(numerator,denominator,resString);
        return resString;
    }

    long *tmpString=(long *)malloc(10001 * sizeof(long));         //保存余数的数组，判断是否存在循环
    memset(tmpString,-1,10001);

//此处将resString字符串首位空出为‘-’做保留；
    unsigned long index=strlen(resString+1);
    resString[index+1]='.';

    long number1=n%d;           //余数
    tmpString[index+1]=number1;
    for(unsigned long i=index+2;i<10000;i++)
    {
        n=number1 *10;
        long resNumber=n/d;        //商
        number1=n%d;           //余数
        int repeatPlace=finderepeat(number1,index+1,tmpString);
        resString[i]=resNumber+'0';
        if(number1==0)
            break;
        if(repeatPlace!=-1)           //找到一个相同的余数，用此余数*10/d时会得到一个相同的数，从而形成循环；
        {
            unsigned long j;
// 将resString字符串中后续字符向后移动；
            for(j=i;j>repeatPlace;j--)
                resString[j+1]=resString[j];
            resString[j+1]='(';
            resString[i+2]=')';
            break;
        }
        else
            tmpString[i]=number1;
    }
    resString=symboljust(numerator,denominator,resString);
    return resString;
}
