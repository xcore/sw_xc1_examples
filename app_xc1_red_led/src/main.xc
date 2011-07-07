// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 ============================================================================
 Name        : $(sourceFile)
 Description : Red LED illumination for the XC-1 board 
 ============================================================================
 */

#include <platform.h>

out port cled0 = PORT_CLOCKLED_0;
out port cledG = PORT_CLOCKLED_SELG;
out port cledR = PORT_CLOCKLED_SELR;

int main(void) {
  /* Disable GREEN line */
  cledG <: 0;
  
  /* Enable RED line */
  cledR <: 1;    
  
  /* LED pattern */
  cled0 <: 0x1;  
  while (1)
  	;
  return 0;
}

