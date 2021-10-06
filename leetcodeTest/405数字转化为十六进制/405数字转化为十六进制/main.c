//
//  main.c
//  405数字转化为十六进制
//
//  Created by 莫玄 on 2021/10/2.
//

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
char * toHex(int num){
    if(num == 0)
        return "0";
    char *stringBuffer=(char *)calloc(9,sizeof(char));
    stringBuffer[8]='\0';
    int count=0;
    for(int i=7;i>=0;i--)
    {
        int val=( num>>(4*i) ) & 0xf;  //获得高4位
        if(val>0 || count>0)
        {
            char n=(val>=10)?('a'+val-10):('0'+val);
            stringBuffer[count]=n;
            count++;
        }
    }
    return stringBuffer;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    char *buffer=toHex(-1);
    printf("%s\n",buffer);
    return 0;
}
