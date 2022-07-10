#include <iostream>
#include <stdlib.h>
#include <bitset>
#include <stdio.h>
#include <string.h>
#include <fstream>
using namespace std;

#define byte unsigned char  // will be used to store byte size (8-bits)
#define word unsigned short // will be used to store word size (16-bits)
#define u32 unsigned int

#define MAX_MEM 1024*64 //Maximum memory
#define REST16 0xff     //rest for 16-bits

// 16-bit registers defined
    // These are 16-bit that are defined by twice 8-bit
#define AX_register16 0    // Accumulator Extended, by AH, AL
#define CX_register16 1    // Count Extended, by CH,CL  
#define DX_register16 2    // Data Extended, by DH,DL
#define BX_register16 3    // Base Extended, by BH, BL
    // These are 16-bit only
#define SP_register16 4    // Stack Pointer
#define BP_register16 5    // Base Pointer
#define SI_register16 6    // Source Index
#define DI_register16 7    // Destination Index

//8-bit registers defined
    // For AX, BX, CX, DX
#define AL_register8 0     // Accumulator Low
#define CL_register8 1     // Count Low
#define DL_register8 2     // Data Low
#define BL_register8 3     // Base Low
#define AH_register8 4     // Accumulator High
#define CH_register8 5     // Count High
#define DH_register8 6     // Data High
#define BH_register8 7     // Base High

// FLAGS register (ZF, SF, CF)  
   // Zero Flag (6-bit), set to 1 if an integer operation produces the result 0, 0 if result is not zero. 
    //(For example, if an operand is subtracted from another of equal value, the Zero flag is set.)  
byte ZF = false;
void zero_flag(byte Z, byte& ZF){
    if(Z==0) ZF = true;   
}

    // Sign Flag (7-bit), set to the most significant bit of the result of an integer operation. 
    //  (indicates that an operation produced a negative result)
word SF = false; // range 0 to 65,535
void sign_flag(word S, word& SF){
    //For (16-bits) registers
    // Although 32768 is not a negative number, but its bigger than 32767, 
    // then it not 16 bits anymore. So, the sign flag is only related to number handled as signed.
    if(S > 32767) SF=true; // -32,768 to 32,767
    //lFor (8-bits) registers
    else if(S >127) SF = true; // Since the sign flag is only related to number handled as signed, char has maximum of 127 postive 
}

// Carry Flag (0-bit), set to 1 if an unsigned integer operation generates a carry 
//or borrow on the most significant bit, 0 otherwise
byte CF = false;
void carry_flag(byte C, byte& CF, byte temp, int add)
{
    if(add == 1){ //add
        if (temp > C)
            CF = true;
    }else //subtract
            {
                if(temp<C)
                    CF = true;         
            }
}

// for memory 
struct Mem
{
//    static  const u32 MAX_MEM = 1024 * 64;
    byte data[MAX_MEM];
    
    void Initialise()
    {
        for(u32 i=0; i<MAX_MEM; i++ )
        {
            data[i] = 0;    // set all the data to Zero before adding to it
        }
    }
};

// for X86 
typedef struct X86 
{
    // 16-bit registers
    word AX;
    word BX;
    word CX;
    word DX;
    word SI;
    word DI;
    // Pointers
    word BP;            // Base Pointer
    word SP = 0x100;    // Stack Pointer
    word IP;            // Instruction Pointer 
    
    word PC;            // program counter
    byte value;         // to store the first value of register
    byte value2;         // to store the second value of register
    byte value3;         // to store the third value of register


	
    byte *mem;          // pointer to memory
    byte *aux_mem;      // to allocate memory 
    
    void Rest(Mem& memory)
    {
        PC = 0xFFFC;
        SP = 0x0100;
        AX =BX= CX = DX = 0;
        word register16[8] = {0,0,0,0,0xFFFC,0,0,0};    //initialize 16-bit registers to zero
        byte register8[8] = {0,0,0,0,0,0,0,0};          //initialize 8-bit registers to zero
        memory.Initialise();
    }
} registers;

byte updateMem(registers *X86, word IP)
{
    // return the incremented memory 
    X86->aux_mem = &X86->mem[ IP ];
    return X86->mem[ IP ];
}

#define REGISTER(operand)	 ((operand) & 0x7)
#define REGISTERS16(high,low)     ((word) (((byte) (low)) | ((word) ((byte) (high)) << 8)))

byte registersEmulate(registers* X86)
{
    byte dataCounter, operand; 
    operand = X86->aux_mem[0];      // store the instuction like MOV, SUB, ADD
    X86->value = X86->aux_mem[1];   // store what the operand value should be for the instuction
    X86->value2 = X86->aux_mem[2];   // store what the operand value2
    byte regi = REGISTER(operand);
    byte Lowbits = X86->AX  & 0xff;
    byte newValue = REGISTERS16(X86->value2, X86->value);

//    byte newL = L - X86->aux_mem[1];
    switch(operand)
    {
        // Increment (16-bit register)
        case 0x40: case 0x41: case 0x42: case 0x43: 
            switch (regi)
            {
                case AX_register16: 
                    X86->AX =  X86->AX+ 1;
                    break;
                case CX_register16:
                    X86->CX =  X86->CX+ 1; 
                    break;
                case DX_register16: 
                    X86->DX =  X86->DX+ 1; 
                    break;
                case BX_register16: 
                    X86->BX =  X86->BX+ 1; 
                    break;
                default:
                    break;
            }
            X86->IP += 1;
            dataCounter = updateMem(X86, X86->IP);
            break;
            
        // Decrement (16-bit register)
        case 0x48: case 0x49: case 0x4A: case 0x4B: 
            switch (regi)
            {
                case AX_register16: 
                    X86->AX =  X86->AX- 1;
                    break;
                case CX_register16:
                    X86->CX =  X86->CX- 1; 
                    break;
                case DX_register16: 
                    X86->DX =  X86->DX- 1; 
                    break;
                case BX_register16: 
                    X86->BX =  X86->BX- 1; 
                    break;
                default:
                    break;
            }
            X86->IP += 1;
            dataCounter = updateMem(X86, X86->IP);
            break;
        
        case 0x02:
        // ADD for 8-bits AL,AL or AL,CL or AL,DL or AL,BL or AL,AH or AL,CH or AL,DH or AL,BH
            if (X86->aux_mem[1] == 0xC0) {  X86->AX = (word) ((X86->AX & 0xff)+ (X86->AX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC1) {  X86->AX = (word) ((X86->AX & 0xff)+ (X86->CX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC2) {  X86->AX = (word) ((X86->AX & 0xff)+ (X86->DX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC3) {  X86->AX = (word) ((X86->AX & 0xff)+ (X86->BX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC4) {  X86->AX = (word) ((X86->AX & 0xff)+ ((X86->AX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC5) {  X86->AX = (word) ((X86->AX & 0xff)+ ((X86->CX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC6) {  X86->AX = (word) ((X86->AX & 0xff)+ ((X86->DX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC7) {  X86->AX = (word) ((X86->AX & 0xff)+ ((X86->BX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
        
        // ADD for 8-bits AL,AL or AL,CL or AL,DL or AL,BL
            if (X86->aux_mem[1] == 0xE0) {  X86->AX = (word) (((X86->AX & 0xff00) >> 8)+ (X86->AX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE1) {  X86->AX = (word) (((X86->AX & 0xff00) >> 8)+ (X86->CX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE2) {  X86->AX = (word) (((X86->AX & 0xff00) >> 8)+ (X86->DX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE3) {  X86->AX = (word) (((X86->AX & 0xff00) >> 8)+ (X86->BX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE4) {  X86->AX = (word) (((X86->AX & 0xff00) >> 8)+ ((X86->AX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE5) {  X86->AX = (word) (((X86->AX & 0xff00) >> 8)+ ((X86->CX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE6) {  X86->AX = (word) (((X86->AX & 0xff00) >> 8)+ ((X86->DX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE7) {  X86->AX = (word) (((X86->AX & 0xff00) >> 8)+ ((X86->BX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );} 
            
            
        // ADD for 8-bits CL,AL or CL,CL or CL,DL or CL,BL or CL,AH or CL,CH or CL,DH or CL,BH
            if (X86->aux_mem[1] == 0xC8) 
                {  X86->CX = (word) ((X86->CX & 0xff)+ (X86->AX & 0xff)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC9) 
                {  X86->CX = (word) ((X86->CX & 0xff)+ (X86->CX & 0xff)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xCA) 
                {  X86->CX = (word) ((X86->CX & 0xff)+ (X86->DX & 0xff)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xCB) 
                {  X86->CX = (word) ((X86->CX & 0xff)+ (X86->BX & 0xff)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xCC) 
                {  X86->CX = (word) ((X86->CX & 0xff)+ ((X86->AX & 0xff00) >> 8)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xCD) 
                {  X86->CX = (word) ((X86->CX & 0xff)+ ((X86->CX & 0xff00) >> 8)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xCE) 
                {  X86->CX = (word) ((X86->CX & 0xff)+ ((X86->DX & 0xff00) >> 8)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xCF) 
                {  X86->CX = (word) ((X86->CX & 0xff)+ ((X86->BX & 0xff00) >> 8)) +( X86->CX  & 0xff00 );}
        
        // ADD for 8-bits CH,AL or CH,CL or CH,DL or CH,BL or CH,AH or CH,CH or CH,DH or CH,BH
            if (X86->aux_mem[1] == 0xE0) 
                {  X86->CX = (word) (((X86->CX & 0xff00) >> 8)+ (X86->AX & 0xff)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE1) 
                {  X86->CX = (word) (((X86->CX & 0xff00) >> 8)+ (X86->CX & 0xff)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE2) 
                {  X86->CX = (word) (((X86->CX & 0xff00) >> 8)+ (X86->DX & 0xff)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE3) 
                {  X86->CX = (word) (((X86->CX & 0xff00) >> 8)+ (X86->BX & 0xff)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE4) 
                {  X86->CX = (word) (((X86->CX & 0xff00) >> 8)+ ((X86->AX & 0xff00) >> 8)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE5) 
                {  X86->CX = (word) (((X86->CX & 0xff00) >> 8)+ ((X86->CX & 0xff00) >> 8)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE6) 
                {  X86->CX = (word) (((X86->CX & 0xff00) >> 8)+ ((X86->DX & 0xff00) >> 8)) +( X86->CX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE7) 
                {  X86->CX = (word) (((X86->CX & 0xff00) >> 8)+ ((X86->BX & 0xff00) >> 8)) +( X86->CX  & 0xff00 );} 
            
        // ADD for 8-bits DL,AL or DL,CL or DL,DL or DL,BL or DL,AH or DL,CH or DL,DH or DL,BH
            if (X86->aux_mem[1] == 0xC0) 
                {  X86->DX = (word) ((X86->DX & 0xff)+ (X86->AX & 0xff)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC1) 
                {  X86->DX = (word) ((X86->DX & 0xff)+ (X86->CX & 0xff)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC2) 
                {  X86->DX = (word) ((X86->DX & 0xff)+ (X86->DX & 0xff)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC3) 
                {  X86->DX = (word) ((X86->DX & 0xff)+ (X86->BX & 0xff)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC4) 
                {  X86->DX = (word) ((X86->DX & 0xff)+ ((X86->AX & 0xff00) >> 8)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC5) 
                {  X86->DX = (word) ((X86->DX & 0xff)+ ((X86->CX & 0xff00) >> 8)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC6) 
                {  X86->DX = (word) ((X86->DX & 0xff)+ ((X86->DX & 0xff00) >> 8)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC7) 
                {  X86->DX = (word) ((X86->DX & 0xff)+ ((X86->BX & 0xff00) >> 8)) +( X86->DX  & 0xff00 );}
        
        // ADD for 8-bits DH,AL or DH,CL or DH,DL or DH,BL or DH,AH or DH,CH or DH,DH or DH,BH
            if (X86->aux_mem[1] == 0xE0) 
                {  X86->DX = (word) (((X86->DX & 0xff00) >> 8)+ (X86->AX & 0xff)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE1) 
                {  X86->DX = (word) (((X86->DX & 0xff00) >> 8)+ (X86->CX & 0xff)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE2) 
                {  X86->DX = (word) (((X86->DX & 0xff00) >> 8)+ (X86->DX & 0xff)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE3) 
                {  X86->DX = (word) (((X86->DX & 0xff00) >> 8)+ (X86->BX & 0xff)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE4) 
                {  X86->DX = (word) (((X86->DX & 0xff00) >> 8)+ ((X86->AX & 0xff00) >> 8)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE5) 
                {  X86->DX = (word) (((X86->DX & 0xff00) >> 8)+ ((X86->CX & 0xff00) >> 8)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE6) 
                {  X86->DX = (word) (((X86->DX & 0xff00) >> 8)+ ((X86->DX & 0xff00) >> 8)) +( X86->DX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE7) 
                {  X86->DX = (word) (((X86->DX & 0xff00) >> 8)+ ((X86->BX & 0xff00) >> 8)) +( X86->DX  & 0xff00 );}

        // ADD for 8-bits BL,AL or BL,CL or BL,DL or BL,BL or BL,AH or BL,CH or BL,DH or BL,BH
            if (X86->aux_mem[1] == 0xC0) 
                {  X86->AX = (word) ((X86->AX & 0xff)+ (X86->AX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC1) 
                {  X86->AX = (word) ((X86->AX & 0xff)+ (X86->CX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC2) 
                {  X86->AX = (word) ((X86->AX & 0xff)+ (X86->DX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC3) 
                {  X86->AX = (word) ((X86->AX & 0xff)+ (X86->BX & 0xff)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC4) 
                {  X86->AX = (word) ((X86->AX & 0xff)+ ((X86->AX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC5) 
                {  X86->AX = (word) ((X86->AX & 0xff)+ ((X86->CX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC6) 
                {  X86->AX = (word) ((X86->AX & 0xff)+ ((X86->DX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xC7) 
                {  X86->AX = (word) ((X86->AX & 0xff)+ ((X86->BX & 0xff00) >> 8)) +( X86->AX  & 0xff00 );}
        
        // ADD for 8-bits BH,AL or BH,CL or BH,DL or BH,BL or BH,AH or BH,CH or BH,DH or BH,BH
            if (X86->aux_mem[1] == 0xE0) 
                {  X86->BX = (word) (((X86->BX & 0xff00) >> 8)+ (X86->AX & 0xff)) +( X86->BX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE1) 
                {  X86->BX = (word) (((X86->BX & 0xff00) >> 8)+ (X86->CX & 0xff)) +( X86->BX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE2) 
                {  X86->BX = (word) (((X86->BX & 0xff00) >> 8)+ (X86->DX & 0xff)) +( X86->BX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE3) 
                {  X86->BX = (word) (((X86->BX & 0xff00) >> 8)+ (X86->BX & 0xff)) +( X86->BX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE4) 
                {  X86->BX = (word) (((X86->BX & 0xff00) >> 8)+ ((X86->AX & 0xff00) >> 8)) +( X86->BX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE5) 
                {  X86->BX = (word) (((X86->BX & 0xff00) >> 8)+ ((X86->CX & 0xff00) >> 8)) +( X86->BX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE6) 
                {  X86->BX = (word) (((X86->BX & 0xff00) >> 8)+ ((X86->DX & 0xff00) >> 8)) +( X86->BX  & 0xff00 );}
            if (X86->aux_mem[1] == 0xE7) 
                {  X86->BX = (word) (((X86->BX & 0xff00) >> 8)+ ((X86->BX & 0xff00) >> 8)) +( X86->BX  & 0xff00 );}  
            X86->IP += 2;
            dataCounter = updateMem(X86, X86->IP);
            break;
            
            
            X86->IP += 2;
            dataCounter = updateMem(X86, X86->IP);
            break;
            
        case 0x03:
            // ADD for 16-bits for AX,AX or AX,CX or AX,DX or AX,BX
            if (X86->aux_mem[1] == 0xC0 ) {  X86->AX = X86->AX + X86->AX;} 
            if (X86->aux_mem[1] == 0xC1 ) {  X86->AX = X86->AX + X86->CX;} 
            if (X86->aux_mem[1] == 0xC2 ) {  X86->AX = X86->AX + X86->DX;}
            if (X86->aux_mem[1] == 0xC3 ) {  X86->AX = X86->AX + X86->BX;}

            // ADD for 16-bits for CX,AX or CX,CX or CX,DX or CX,BX
            if (X86->aux_mem[1] == 0xC8 ) {  X86->CX = X86->CX + X86->AX;} 
            if (X86->aux_mem[1] == 0xC9 ) {  X86->CX = X86->CX + X86->CX;} 
            if (X86->aux_mem[1] == 0xCA ) {  X86->CX = X86->CX + X86->DX;} 
            if (X86->aux_mem[1] == 0xCB ) {  X86->CX = X86->CX + X86->BX;} 

            // ADD for 16-bits for DX,AX or DX,CX or DX,DX or DX,BX
            if (X86->aux_mem[1] == 0xD0 ) {  X86->DX = X86->DX + X86->AX;} 
            if (X86->aux_mem[1] == 0xD1 ) {  X86->DX = X86->DX + X86->CX;} 
            if (X86->aux_mem[1] == 0xD2 ) {  X86->DX = X86->DX + X86->DX;} 
            if (X86->aux_mem[1] == 0xD3 ) {  X86->DX = X86->DX + X86->BX;} 

            // ADD for 16-bits for BX,AX or BX,CX or BX,DX or BX,BX
            if (X86->aux_mem[1] == 0xD8 ) {  X86->BX = X86->BX + X86->AX;} 
            if (X86->aux_mem[1] == 0xD9 ) {  X86->BX = X86->BX + X86->CX;} 
            if (X86->aux_mem[1] == 0xDA ) {  X86->BX = X86->BX + X86->DX;} 
            if (X86->aux_mem[1] == 0xDB ) {  X86->BX = X86->BX + X86->BX;} 

            X86->IP += 2;
            dataCounter = updateMem(X86, X86->IP);
            break;

        case 0x04:
            // ADD for AL,i
            X86 ->AX = (word) (Lowbits +X86->aux_mem[1]) +(X86->AX & 0xff00);    
            X86->IP += 2;
            dataCounter = updateMem(X86, X86->IP);
            break;

        case 0x05:
            // ADD for AX,i
            X86 ->AX =  X86 ->AX +newValue;
            X86->IP += 3;
            dataCounter = updateMem(X86, X86->IP);
            break;
            
            
         // MOV instruction for 16-bits
        case 0xb8: case 0xb9: case 0xbA: case 0xbB: case 0xbC: case 0xbD: case 0xbE: case 0xbF:
            switch(regi)
            {
            case AX_register16: 
                X86->AX = newValue; 
                break;
            case CX_register16:
                X86->CX = newValue; 
                break;
            case DX_register16: 
                X86->DX = newValue; 
                break;
            case BX_register16: 
                X86->BX = newValue; 
                break;
            case SP_register16: 
                X86->SP = newValue; 
                break;
            case BP_register16: 
                X86->BP = newValue; 
                break;
            case SI_register16: 
                X86->SI = newValue;
                break;
            case DI_register16: 
                X86->DI = newValue; 
                break;
            default:
                break;
            }
            X86->IP += 3;
            dataCounter = updateMem(X86, X86->IP);
            break;
        
         // MOV instruction for 8-bits
        case 0xb0: case 0xb1: case 0xb2: case 0xb3: case 0xb4: case 0xb5: case 0xb6: case 0xb7:
            switch(regi)
            {
            case AX_register16: 
                X86->AX = (word) X86->value + ( X86->AX & 0xff00 );
                break;
            case CX_register16: 
                X86->CX = (word) X86->value + ( X86->CX & 0xff00 ); 
                break;
            case DX_register16: 
                X86->DX = (word) X86->value + ( X86->DX & 0xff00 ); 
                break;
            case BX_register16: 
                X86->BX = (word) X86->value + ( X86->BX & 0xff00 ); 
                break;
            case AH_register8: 
                X86->AX = (word) (((word)X86->value << 8) + (X86->AX & 0xff)); // to get AH shift bits >> by 8
                break; 
            case CH_register8: 
                X86->CX = (word) (((word)X86->value << 8) + (X86->CX & 0xff)); // to get AH shift bits >> by 8
                break; 
            case DH_register8: 
                X86->DX = (word) (((word)X86->value << 8) + (X86->DX & 0xff)); // to get AH shift bits >> by 8
                break;  
            case BH_register8: 
                X86->BX = (word) (((word)X86->value << 8) + (X86->BX & 0xff)); // to get AH shift bits >> by 8
                break; 
            default:
                break;
            }
            X86->IP += 2;
            dataCounter = updateMem(X86, X86->IP);
            break;
        
            // subtraction for 16 bit regs
        case 0x2D:
            X86->AX = X86->AX - newValue;           // SUB for AX,i
            X86->IP += 3;
            dataCounter = updateMem(X86, X86->IP);
            break;
        
        case 0x81:
            if (X86->aux_mem[1] == 0xE9)  
                { 
                    X86->CX = X86->CX - newValue;   // SUB for CX,i
                } 
            if (X86->aux_mem[1] == 0xEA)    
                { 
                    X86->DX = X86->DX - newValue;   // SUB for DX,i
                } 
            if (X86->aux_mem[1] == 0xEB)    
                { 
                    X86->BX = X86->BX - newValue;   // SUB for BX,i
                } 
                
            if (X86->aux_mem[1] == 0xC1)    
                { 
                    X86->CX = X86->CX + newValue;   // ADD for BX,i
                } 
            if (X86->aux_mem[1] == 0xC2)    
                { 
                    X86->DX = X86->DX + newValue;   // ADD for BX,i
                } 
            if (X86->aux_mem[1] == 0xC3)    
                { 
                    X86->BX = X86->BX + newValue;   // ADD for BX,i
                } 
            X86->IP += 4;
            dataCounter = updateMem(X86, X86->IP);
            break;
            
        case 0x83:
            if (X86->aux_mem[1] == 0xE9)  
                { 
                    X86->CX = X86->CX - X86->aux_mem[2];   // SUB for CX,i
                } 
            if (X86->aux_mem[1] == 0xEA)    
                { 
                    X86->DX = X86->DX - X86->aux_mem[2];   // SUB for DX,i
                } 
            if (X86->aux_mem[1] == 0xEB)    
                { 
                    X86->BX = X86->BX - X86->aux_mem[2];   // SUB for BX,i
                } 
                
            if (X86->aux_mem[1] == 0xC1)    
                { 
                    X86->CX = X86->CX + X86->aux_mem[2];   // ADD for BX,i
                } 
            if (X86->aux_mem[1] == 0xC2)    
                { 
                    X86->DX = X86->DX + X86->aux_mem[2];   // ADD for BX,i
                } 
            if (X86->aux_mem[1] == 0xC3)    
                { 
                    X86->BX = X86->BX + X86->aux_mem[2];   // ADD for BX,i
                } 
            X86->IP += 3;
            dataCounter = updateMem(X86, X86->IP);
            break;
            
        // Subtraction for the 8 bit regs
        case 0x2C:
            X86 ->AX = (word) (Lowbits -X86->aux_mem[1]) +(X86->AX & 0xff00);         // SUB for AL,i
            X86->IP += 2;
            dataCounter = updateMem(X86, X86->IP);
            break;
            
        case 0x80:
             if (X86->aux_mem[1] == 0xC1) 
                { 
                     X86 ->CX = (word) (Lowbits-X86->aux_mem[2]) +(X86->CX & 0xff00); // ADD for CL,i
                } 
            if (X86->aux_mem[1] == 0xC2) 
                { 
                     X86 ->DX = (word) (Lowbits -X86->aux_mem[2]) +(X86->DX & 0xff00); // ADD for DL,i
                } 
            if (X86->aux_mem[1] == 0xC3) 
                { 
                     X86 ->BX = (word) (Lowbits -X86->aux_mem[2]) +(X86->BX & 0xff00);  // ADD for BL,i
                } 
            if (X86->aux_mem[1] == 0xC4) 
                { 
                     X86 ->AX = (word) (Lowbits -X86->aux_mem[2]) +(X86->AX & 0xff00); // ADD for AH,i
                } 
            if (X86->aux_mem[1] == 0xC5) 
                { 
                     X86 ->CX = (word) (Lowbits-X86->aux_mem[2]) +(X86->CX & 0xff00); // ADD for CH,i
                } 
            if (X86->aux_mem[1] == 0xC6) 
                { 
                    X86 ->DX = (word) (Lowbits -X86->aux_mem[2]) +(X86->DX & 0xff00); // ADD for DH,i
                } 
            if (X86->aux_mem[1] == 0xC7) 
                { 
                    X86 ->BX = (word) (Lowbits -X86->aux_mem[2]) +(X86->BX & 0xff00); // ADD for BH,i
                } 
                
            // SUB for 8-bits 
            if (X86->aux_mem[1] == 0xE9) 
                { 
                     X86 ->CX = (word) (Lowbits-X86->aux_mem[2]) +(X86->CX & 0xff00); // SUB  for CL,i
                } 
            if (X86->aux_mem[1] == 0xEA) 
                { 
                     X86 ->DX = (word) (Lowbits -X86->aux_mem[2]) +(X86->DX & 0xff00); // SUB for DL,i
                } 
            if (X86->aux_mem[1] == 0xEB) 
                { 
                     X86 ->BX = (word) (Lowbits -X86->aux_mem[2]) +(X86->BX & 0xff00);  // SUB for BL,i
                } 
            if (X86->aux_mem[1] == 0xEC) 
                { 
                     X86 ->AX = (word) (Lowbits -X86->aux_mem[2]) +(X86->AX & 0xff00); // SUB for AH,i
                } 
            if (X86->aux_mem[1] == 0xED) 
                { 
                     X86 ->CX = (word) (Lowbits-X86->aux_mem[2]) +(X86->CX & 0xff00); // SUB for CH,i
                } 
            if (X86->aux_mem[1] == 0xEE) 
                { 
                    X86 ->DX = (word) (Lowbits -X86->aux_mem[2]) +(X86->DX & 0xff00); // SUB for DH,i
                } 
            if (X86->aux_mem[1] == 0xEF) 
                { 
                    X86 ->BX = (word) (Lowbits -X86->aux_mem[2]) +(X86->BX & 0xff00); // SUB for BH,i
                } 
            X86->IP += 3;
            dataCounter = updateMem(X86, X86->IP);
            break;
            
        default:
            return 0xC3;
            break; 
    }
    
   return dataCounter;
}

int main()  
{
    Mem mem;
    X86 x86_Emulator;
    
    FILE *myFile = fopen("EXAMPLE.com", "rb");   // To open the file. Change Example to whatever file you would like to open
    if (myFile == NULL)     // cheking if the file exists or not
    {   
        cout<<("Cannot open the file.\nERROE: No file found. ")<<endl;
    } else {    // file is found
        cout << ("File was found. ") <<endl;
        cout << ("Processing the file... ") <<endl;
        
        registers *X86 = NULL;
        
        fseek(myFile,0,SEEK_END);
        size_t fileSize = (size_t)ftell(myFile);
        cout << "Number of characters inside the file are: "<< (fileSize) <<endl;    // prints the size (number of characters in the file)
        fseek(myFile,0,SEEK_SET);
        
        X86 =  (registers*)malloc( sizeof( registers) );
        memset(X86, 0, sizeof(registers));  // 1st: provide ptr to block of mem to fill, 2nd: value to be set, 3rd: # of byte ro be set ot vallue
        X86->mem = (byte*)malloc(MAX_MEM);
        X86->aux_mem = X86->mem;
        memset( X86->mem, 0, MAX_MEM );
        X86->SP = 0x100;

        
        if (fileSize <= MAX_MEM)    // check if file size is smaller than the max memory of 65536
        {
            size_t result;  // to store what the file contains
            result =  fread(X86->mem, 1, fileSize, myFile); // store the file into the memory.
            fclose(myFile);
            
            // // prints the code it self in assembly
             cout << ("\nThe file contain the following assembly code: ") <<endl;
             ifstream myFile("Example.com.~asm");
             if(myFile.is_open())
             {
                 cout << myFile.rdbuf();
             } 
            if(result == fileSize)
            {
                while (1)
                {
                	byte PC = registersEmulate(X86); // program counter
            
            		if( REST16 == PC )
            		{
            			break;
            		} else {
                            X86->IP += 3; // move instruction pointer up by 3 memory spaces for the next instruction
                            if ( X86->mem[X86->IP] != 0x00)
                            {   // To avoid the flag error, check if not 0 yet then -1
                                X86->IP -= 1;
                            }
                            
                    		X86->aux_mem = &X86->mem[X86->IP]; // store into aux_mem
                    	
                            if (PC == 0xCD)
                            {   // we return 
                                break;
                            }
                      }
                }
            }
        }
        
        printf("\n AX = %X\n ", X86->AX);
        printf("BX = %X\n ", X86->BX);
        printf("CX = %X\n ", X86->CX);
        printf("DX = %X\n ", X86->DX);  
        printf("ZF = %X\n ", ZF);
        printf("SF = %X\n ", SF);
        printf("CF = %X\n ", CF);
    }
    return 0;
}