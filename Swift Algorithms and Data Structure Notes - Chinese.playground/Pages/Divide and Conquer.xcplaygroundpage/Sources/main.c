//  功能: n階河洛塔求解  File_Name: main.c
//  Created by Sean LH Lee on 2014/11/11.
//  Copyright (c) 2014年 Sean LH Lee. All rights reserved.

#include <stdio.h>
int count=0;                                                //移動次數變數
void iniStat(int, char *);                                  //宣告 河洛塔起始狀態函式 原型
void chSwap(char *, char *);                                //宣告 位置交換函式 原型
void move1(int *, int, char, char, char, char *);           //宣告 解河洛塔函式 原型
void action(int *, char,char,char *);                       //宣告 顯示移動動作函式 原型

int main(void)
{//主程式區段
    int n=0,*N=&n;                                          //求解階數變數n, 指向變數N指向n(用於函式)
    printf("求解幾階河洛塔(input an integer)?");
    while (scanf("%d",&n) != EOF && n>0) {                  //一直讀取輸入直到輸入0
        char s_stat[3][n+1];                                //宣告河洛塔狀態2階陣列
        iniStat(n, s_stat);                                 //取得起始狀態
        puts(s_stat[0]);puts(s_stat[1]);puts(s_stat[2]);    //顯示起始狀態
        move1(N, n,'a', 'b', 'c', s_stat);                  //求解
        //puts(s_stat[0]);puts(s_stat[1]);puts(s_stat[2]);    //顯示解答後狀態
        return 0;
    }
}

void move1(int *N, int n, char A, char B, char C, char *s)
{//解河洛塔的函式: 當河洛塔為少一階時有解, 則河洛塔有解
    if (n>0){
        move1(N, n-1,A,C,B,s);
        count++;
        //printf("%d.move X from %c to %c\n", count, A ,B);
        action(N,A,B,s);                                    //根據解得之步驟顯示移動動作
        move1(N,n-1,C,B,A,s);
    }
}

void action(int *N, char a,char b,char *s)
{//顯示移動動作函式, 根據解得之步驟與當前之狀態, 進行移動動作並顯示
    int i,j,ii,jj;                                          //求得移動位置的相關變數
    if (a=='a')
        ii=0;
    else if (a=='b')
        ii=1;
    else
        ii=2;
    if (b=='a')
        jj=0;
    else if (b=='b')
        jj=1;
    else
        jj=2;
    for (i=0;*(s+ii*(*N+1)+i)=='0' && i<=(*N-1);i++){}
    for (j=0;*(s+jj*(*N+1)+j)=='0'&& j<=(*N-1);j++){}
    //puts(s);puts(s+*N+1);puts(s+2**N+2);
    printf("%d. Move %c from %c to %c replace %c\n", count, *(s+ii*(*N+1)+i),a, b, *(s+jj*(*N+1)+j-1));
    //printf("(ii=%d,i=%d,jj=%d,j=%d)\n",ii, i, jj, j);
    chSwap(s+ii*(*N+1)+i, s+jj*(*N+1)+j-1);
    puts(s);puts(s+*N+1);puts(s+2**N+2);
}

void iniStat(int n, char *s)
{//宣告河洛塔起始狀態函式
    for (int j=0;j<n;j++)
        *(s+j)=65+j;
    for(int i=1;i<3;i++)
        for(int j=0;j<n;j++)
            *(s+(n+1)*i+j)='0';
    for (int i=0; i<3; i++)
        *(s+(n+1)*i+n)='\0';
}

void chSwap(char *ch1, char *ch2)
{//字元交換函式
    char chTemp;
    chTemp=*ch1;
    *ch1=*ch2;
    *ch2=chTemp;
}
