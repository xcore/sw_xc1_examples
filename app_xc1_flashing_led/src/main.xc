// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 ============================================================================
 Name        : $(sourceFile)
 Description : Flashing LED program for the XC-1 board 
 ============================================================================
 */

#include <platform.h>
#define FLASH_PERIOD 20000000

out port cled0 = PORT_CLOCKLED_0;
out port cledG = PORT_CLOCKLED_SELG;
out port cledR = PORT_CLOCKLED_SELR;

int main(void) {
  timer tmr;
  unsigned ledGreen = 1;
  unsigned t;
  tmr :> t;
  while (1) {
    cledG <: ledGreen;
    cledR <: !ledGreen;
    cled0 <: 0x1;
    t += FLASH_PERIOD;
    tmr when timerafter(t) :> void;
    ledGreen = !ledGreen;
  }
  return 0;
}
