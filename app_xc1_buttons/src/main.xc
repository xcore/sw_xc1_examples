// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 ============================================================================
 Name        : $(sourceFile)
 Description : Flash and cycle LEDs at different rates and respond to buttons 
 ============================================================================
*/

#include <platform.h>

void cycleLED(out port led0, out port led1, out port led2, 
    out port ledG, out port ledR, int flash_period, int cycle_period);

void buttonListener(in port b, out port spkr);

#define FLASH_PERIOD 10000000
#define CYCLE_PERIOD 60000000
#define TDELAY 100000
#define TLENGTH 500

out port cled0 = PORT_CLOCKLED_0;
out port cled1 = PORT_CLOCKLED_1;
out port cled2 = PORT_CLOCKLED_2;
out port cledG = PORT_CLOCKLED_SELG;
out port cledR = PORT_CLOCKLED_SELR;
in port buttons = PORT_BUTTON;
out port speaker = PORT_SPEAKER;

int main(void) {
  
  par{
    cycleLED(cled0, cled1, cled2, cledG, cledR, FLASH_PERIOD, CYCLE_PERIOD);
    buttonListener(buttons, speaker);
  }
	
  return 0;
}

void cycleLED(out port led0, out port led1, out port led2, 
    out port ledG, out port ledR, int flash_period, int cycle_period){

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
        ledG <: ledOn;
        timeF += flash_period;
        break;
      case tmrC when timerafter(timeC) :> void:
        led0 <: ledVal;
        led1 <: (ledVal >> 4);
        led2 <: (ledVal >> 8);
        ledVal <<= 1;
        if (ledVal == 0x1000)
          ledVal = 1;
        timeC += cycle_period;
        break;
    }
  }
  return;
}

void buttonListener(in port b, out port spkr) {
  timer tmr;
  int t, isOn = 1;
  while (1) {
    b when pinsneq(0xf) :> void;
    tmr :> t;
    for (int i=0; i<TLENGTH; i++) {
      isOn = !isOn;
      t += TDELAY;
      tmr when timerafter(t) :> void;
      spkr <: isOn;
    }
  }
  return;
}

