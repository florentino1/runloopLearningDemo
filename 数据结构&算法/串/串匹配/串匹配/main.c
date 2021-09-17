//
//  main.c
//  串匹配
//
//  Created by 莫玄 on 2021/8/17.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define debug
#pragma mark-暴力解1
int indexString1(char s[],char t[],int pos)
{
    unsigned long ls=strlen(s);//主串
    unsigned long lt=strlen(t);//模式串
    for(int i=pos;i<ls-lt;i++)
    {
        int j;
        for(j=0;j<lt;j++)
        {
            if(s[i+j]!=t[j])//字符不匹配时，主串指针后移1位，模式串指针归零；
                break;
        }
        if(j==lt)//结束循环时判断模式串是否已经到末尾，到末尾时返回i即为模式串在主串中的匹配起始；
            return i;
    }
    return (int)ls;//主串已经到达末尾；
}
#pragma mark-暴力解2,双指针法
int indexString2(char s[],char t[],int pos)
{
    unsigned long ls=strlen(s);//主串
    unsigned long lt=strlen(t);//模式串
    int i=pos;
    int j=0;
    while (i<ls && j<lt) {
        if(s[i]==t[j])//字符匹配时 双指针均后移一位
        {
            i++;
            j++;
        }
        else
        {
            i=i-j+1;//字符不匹配时，主串的指针需要还原到原位后再后移一位；模式串指针归零；
            j=0;
        }
    }
    if(j==lt)//模式串已经到达末尾,找到匹配的子串
        return (int)(i-lt);
    else//主串已经到达末尾，没有匹配的子串
        return (int)ls;

}
#pragma mark-KMP算法
void get_nextvalue(char s[],int *a)//只考虑在主串和模式串不匹配时，将模式串作为主串和模式串 进行再匹配；
{
    a[0]=-1;//即模式串的首位与主串不匹配时，将模式串本身作为主串：此时模式串s[0]不存在部分重复结构
    a[1]=0;//即当模式串中的第1位与主串不匹配时，将模式串本身作为主串：此时模式串s[0,1]不存在部分重复结构,即主串（此处即是模式串本身）中的某位需要和模式串的首位进行比较：next[i]=0；
    unsigned long len=strlen(s);
    int i=1;//i表示主串和模式串当前不匹配的位置,即模式串中的i位与主串中的某位不匹配，但是只考虑模式串本身的结构是否存在部分重复
    int j=0;
    while(i<(int)len)
    {
        if(j==-1 || s[i]==s[j])
        {
            i++;
            j++;
            if(s[i]!=s[j])
                a[i]=j;
            else
                a[i]=a[j];
        }
        else
            j=a[j];
    }
}
int indexString3(char s[],char t[],int pos)//KMP主程序
{
    unsigned long ls=strlen(s);//主串
    unsigned long lt=strlen(t);//模式串
    int i=pos;
    int j=0;
    int next[lt];
    get_nextvalue(t,next);
#ifdef debug
    printf("next array: \n");
    for(int i=0;i<lt;i++)
    printf("%d ",next[i]);
#endif
    while (i<(int)ls && j<(int)lt)//此处的比较 ls和lt是无符号数，无符号数与有符号数的比较会被转化为无符号数的比较 导致(int)-1 > (unsigned long)4;
    {
        if(j==-1||s[i]==t[j])//字符匹配时 双指针均后移一位;或是特例j=-1时；
        {
            i++;
            j++;
        }
        else
            j=next[j];//模式串在j位置处不匹配时，查询next数组中模式串位置next[j]=k：需要与主串中i进行比较的位置；
        //首字符不匹配时，j==0；此时next[j]=next[0]应该==-1.所以要把j==-1设为特例，即首字母不匹配时，双指针均需要后移一位；
    }
    if(j==lt)//模式串已经到达末尾,找到匹配的子串
        return (int)(i-lt);
    else//主串已经到达末尾，没有匹配的子串
        return (int)ls;
}
#pragma mark-boyer-moore算法
int indexString4(char s[],char t[],int pos)
{
    unsigned long ls=strlen(s);//主串
    unsigned long lt=strlen(t);//模式串

    int *right=(int *)malloc(256*sizeof(int));//辅助的散列表数组，在模式串中不存在的字符在数组的映射为-1，在模式串中存在的字符在数组中映射为距离模式串首的长度；
    memset(right, -1, 256*sizeof(int));
    for(int j=0;j<lt;j++)
    right[t[j]]=j;

    int skip;
    for(int i=0;i<(int)ls-(int)lt;i+=skip)//外部循环 用于主串指针的右移；
    {
        skip=0;
        for(int j=(int)lt-1;j>=0;j--)//内部循环，将内部指针放在模式串的尾部，从右往左同主串字符进行匹配
        {
            if(s[i+j]!=t[j])//模式串与主串字符不匹配时
            {
                skip=j-right[s[i+j]];//right[i+j]表示主串中字符s[i+j]是否存在于模式串中，不存在则right[s[i+j]]为-1，skip=j+1；
                //如果存在则right[s[i+j]]为该字符在模式串中最晚的位置
                if(skip<=0)//当skip<=0时，表示下次比较时模式串原地不动或是向左移动，此时需要将主串指针强制加1，然后重置模式串指针j到串尾；
                    skip=1;
                break;;
            }//模式串与主串字符匹配时，模式串从右到左依次与主串字符进行匹配
        }
        if(skip==0)
            return i;
    }
    return (int)ls;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    char s[20]="ababababccdfed";
    char t[5]="babc";
    int index=indexString4(s, t, 0);
    printf("%d\n",index);
    return 0;
}
