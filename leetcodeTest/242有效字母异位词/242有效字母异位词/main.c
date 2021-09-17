//
//  main.c
//  242有效字母异位词
//
//  Created by 莫玄 on 2021/8/4.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int isAnagram(char * s, char * t){//超出时间限制
    int la=strlen(s);
    int lb=strlen(t);
    if(la!=lb)
        return 0;
    if(la==1)
    {
        if(s[0]==t[0])
        return 1;
        else
        return 0;
    }
    //将s与t分别按照从小到大进行排序
   for(int i=1;i<la;i++)//第一层循环，遍历数组中的每一个元素
    {
        char tmp=s[i];
        int j;
        for(j=i-1;j>=0;j--)//第二层循环，遍历i之前数组，找到最小值
        {
            if(tmp<s[j])//若tmp小于j的值，则比较下一项；若tmp大于j的值，则说明tmp为0~j的最大值，且0~j的数组已经完成排序；
            {
                s[j+1]=s[j];
            }
            else
                break;;
        }
        s[j+1]=tmp;//插入待排序的值
    }
    for(int i=1;i<lb;i++)//第一层循环，遍历数组中的每一个元素
    {
        char tmp=t[i];
        int j;
        for(j=i-1;j>=0;j--)//第二层循环，遍历i之前数组，找到最小值
        {
            if(tmp<t[j])//如果就tmp小于j的值，则比较下一项；若tmp大于j的值，则说明tmp为0~j的最大值，且0~j的数组已经完成排序；
            {
                t[j+1]=t[j];
            }
            else
                break;;
        }
        t[j+1]=tmp;//插入待排序的值
    }
    for(int i=0;i<la;i++)
    {
        if(s[i]!=t[i])
            return 0;
    }
    return 1;
}
int cmp(const void * a,const void * b)
{
    char i=*(char *)a;
    char j=*(char *)b;
    return i-j;
}
int isAnagram1(char *s,char *t)//ok
{
    int la=strlen(s);
    int lb=strlen(t);
    qsort(s, la, sizeof(char ), cmp);
    qsort(t, lb, sizeof(char), cmp);
    return strcmp(s, t)==0;
}
int isAnagram2(char *s,char *t)//使用hash
{
    int la=strlen(s);
    int lb=strlen(t);
    if(la!=lb)
        return 0;
    if(la==1)
    {
        if(s[0]==t[0])
        return 1;
        else
        return 0;
    }

    char *hashs=(char *)calloc(200, sizeof(char));
    char *hasht=(char *)calloc(200,sizeof(char));
    for (int i=0; i<la;i++ )
    {
        char tmp=s[i];
      //  int a=tmp;
        char tmp1=t[i];
       // int b=tmp1;
        hashs[tmp]++;
        hasht[tmp1]++;
    }
    for(int j=0;j<200;j++)
    {
        if(hasht[j]!=hashs[j])
            return 0;
    }
    return 1;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    char s[4]="rat";
    char t[4]="cat";
    int ans=isAnagram2(&s,&t);
    printf("%d\n",ans);
    return 0;
}
