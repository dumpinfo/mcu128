/*
   //*************************************************************************
   //
   //                  P H I L I P S   P R O P R I E T A R Y
   //
   //           COPYRIGHT (c)   1997 BY PHILIPS SINGAPORE.
   //                     --  ALL RIGHTS RESERVED  --
   //
   // File Name:        EPPHAL.H
   // Author:           Wenkai Du
   // Created:          19 Dec 97
   // Modified:
   // Revision:         2.1
   //
   //*************************************************************************
   //
   // 98/11/27			Move part of defination from D12CI.H (WK)
   //*************************************************************************
   */


#ifndef __EPPHAL_H__
#define __EPPHAL_H__

	#define CPLD_CNT0 0x00
	#define CPLD_CNT1 0x01

	#define COUNT_L   0x00
	#define COUNT_H   0x00
	#define EPP_PORT  P1
	#define DATA_BUS  P0


	sbit MCU_SWM0     = P1^0;
	sbit MCU_SWM1     = P1^1;
	sbit MCU_SWM2     = P1^2;
	sbit MCU_SWM3     = P1^3;
	sbit MCU_LED0	  = P1^4;
	sbit MCU_LED1	  = P3^3;
	#define DISABLE		EA=0
	#define ENABLE		EA=1

#endif
