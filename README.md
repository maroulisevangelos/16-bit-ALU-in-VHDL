# 16-bit-ALU-in-VHDL
This repository contains the VHDL implementation of a 16-bit Arithmetic Logic Unit (ALU) designed using a structural approach.

Features
  
  The ALU performs the following operations on 16-bit inputs:

  Arithmetic operations (with overflow detection):
  
    Addition (ADD)
    Subtraction (SUB)
    
  Logical operations:
  
    AND
    OR
    XOR
    NOR
    NAND
    
  The design consists of modular components:
  
    1-bit ALU: Implements basic operations (AND, OR, ADD, SUB, XOR, NOR, NAND).
    16-bit ALU: Constructed by cascading 16 1-bit ALU slices using a ripple carry adder for arithmetic operations.
