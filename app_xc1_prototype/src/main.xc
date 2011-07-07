// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 ============================================================================
 Name        : $(sourceFile)
 Description : Prototype code for the XC-1 board 
 ============================================================================
 */

#include <xs1.h>
#include <platform.h>

on stdcore[0] : in port buttons = PORT_BUTTON;
on stdcore[0] : out port speaker = PORT_SPEAKER;
on stdcore[2] : in port uartIn = XS1_PORT_1A;
on stdcore[2] : out port uartOut = XS1_PORT_1B;

void buttonListener(in port buttons, chanend c);
void transmit(out port uartOut, chanend c);
void receive(in port uartIn, chanend d);
void speakerListener(chanend d, out port speaker);

int main(void) {
  chan c, d;
  par {
    on stdcore[0] : buttonListener(buttons, c);
    on stdcore[2] : transmit(uartOut, c);
    on stdcore[2] : receive(uartIn, d);
    on stdcore[0] : speakerListener(d, speaker);
  }
  return 0;
}

void buttonListener(in port buttons, chanend c){
}

void transmit(out port uartOut, chanend c){
}

void receive(in port uartIn, chanend d){
}

void speakerListener(chanend d, out port speaker){
}
