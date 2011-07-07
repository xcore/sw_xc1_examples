// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 ============================================================================
 Name        : $(sourceFile)
 Description : Flash and cycle LEDs at different rates 
 ============================================================================
 */

#include <platform.h>

#define FLASH_PERIOD 10000000
#define CYCLE_PERIOD 60000000

out port cled0 = PORT_CLOCKLED_0;
out port cled1 = PORT_CLOCKLED_1;
out port cled2 = PORT_CLOCKLED_2;
out port cledG = PORT_CLOCKLED_SELG;
out port cledR = PORT_CLOCKLED_SELR;

int main(void) {

  unsigned ledOn = 1;
  unsigned ledVal = 1;
  timer tmrF, tmrC;
  unsigned timeF, timeC;
  tmrF :> timeF;
  tmrC :> timeC;

  while (1) {
    select {
      case tmrF when timerafter(timeF) :> void:
        ledOn = !ledOn;
        cledG <: ledOn;
        timeF += FLASH_PERIOD;
        break;
      case tmrC when timerafter(timeC) :> void:
        cled0 <: ledVal;
        cled1 <: (ledVal >> 4);
        cled2 <: (ledVal >> 8);
        ledVal <<= 1;
        if (ledVal == 0x1000)
          ledVal = 1;
        timeC += CYCLE_PERIOD;
        break;
    }
  }
  return 0;
}
