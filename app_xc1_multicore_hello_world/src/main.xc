// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 ============================================================================
 Name        : mult.xc
 Description : Multicore Hello World in XC using channels 
 ============================================================================
 */

#include <print.h>
#include <platform.h>

void hello0(chanend cout);
void hello1(chanend cin, chanend cout);
void hello2(chanend cin, chanend cout);
void hello3(chanend cin);

int main(void) {

    chan c1, c2, c3;
    
	par{
		on stdcore[0] : hello0(c1);
		on stdcore[1] : hello1(c1, c2); 	
		on stdcore[2] : hello2(c2, c3);
		on stdcore[3] : hello3(c3);
	}
	return 0;
}

void hello0(chanend cout){
    printstrln("Hello from core 0!");
    cout <: 1;
}

void hello1(chanend cin, chanend cout){
    cin :> int;
    printstrln("Hello from core 1!");
    cout <: 1;
}

void hello2(chanend cin, chanend cout){
    cin :> int;
    printstrln("Hello from core 2!");
    cout <: 1;
}

void hello3(chanend cin){
    cin :> int;
    printstrln("Hello from core 3!");
}

