// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 * ============================================================================
 * Name        : uart-loopback.xc
 * Description : UART loopback example
 * ============================================================================
 */

#include <xs1.h>
#include <print.h>
#include <platform.h>

#define NUM_BYTES 3
#define BIT_RATE 115200
#define BIT_TIME XS1_TIMER_HZ / BIT_RATE

void txBytes(out port txd, char bytes[], int numBytes);
void txByte(out port txd, int byte);
void rxBytes(in port rxd, char bytes[], int numBytes);
char rxByte(in port rxd);


out port txd = XS1_PORT_1H;
in port rxd = XS1_PORT_1I;

int main()
{
	char transmit[] = { 0b00110101, 0b10101100, 0b11110001 };
	char receive[] = { 0, 0, 0 };

	// Drive port high (inactive) to begin
	txd <: 1;
	
	par {
		txBytes(txd, transmit, NUM_BYTES);
		rxBytes(rxd, receive, NUM_BYTES);
	}
	
	return 0;
}

void txBytes(out port txd, char bytes[], int numBytes)
{
	for (int i = 0; i < numBytes; i += 1) {
		txByte(txd, bytes[i]);
	}
	printstrln("txDone"); // Transmit_Done
}

void txByte(out port txd, int byte)
{
	unsigned time;

	// Output start bit
	txd <: 0 @ time; // Endpoint A

	// Output data bits
	for (int i = 0; i < 8; i++) {
		time += BIT_TIME;
		txd @ time <: >> byte; // Endpoint B
	}

	// Output stop bit
	time += BIT_TIME;
	txd @ time <: 1; // Endpoint C

	// Hold stop bit
	time += BIT_TIME;
	txd @ time <: 1; // Endpoint D
}

void rxBytes(in port rxd, char bytes[], int numBytes)
{
	for (int i = 0; i < numBytes; i += 1) {
		bytes[i] = rxByte(rxd);
	}

	printstrln("rxDone");
	for (int i = 0; i < NUM_BYTES; i++) {
		printhexln(bytes[i]);
	}
}

char rxByte(in port rxd)
{
	unsigned byte, time;

	// Wait for start bit
	rxd when pinseq (0) :> void @ time;
	time += BIT_TIME / 2;
	
	// Input data bits
	for (int i = 0; i < 8; i++) {
		time += BIT_TIME;
		rxd @ time :> >> byte;
	}

	// Input stop bit
	time += BIT_TIME;
	rxd @ time :> void;

	return (byte >> 24);
}

