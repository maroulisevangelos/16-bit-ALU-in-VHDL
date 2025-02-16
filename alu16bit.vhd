library ieee;
use ieee.std_logic_1164.all;

--package decleration
package basic_components IS
	 component alu_1_bit is
        port (a:in  std_logic;
              b:in  std_logic;
              Ainvert:in  std_logic;
              Binvert:in  std_logic;
              CarryIn:in  std_logic;
              operation:in  std_logic_vector (1 downto 0);
              result:out std_logic;
              CarryOut:out std_logic);
    end component;
	 component controlcircuit is
        port (opcode:     in  std_logic_vector(2 downto 0);
              Ainvert:    out std_logic;
              Binvert:    out std_logic;
              operation:  out std_logic_vector(1 downto 0);
              CarryIn:    out std_logic);  -- invert a or b, add + 1 for subtract
    end component;
end basic_components;


library ieee;
use ieee.std_logic_1164.all;

--definition of component alu_1_bit
entity alu_1_bit is
    port (
            a:          in  std_logic;
            b:          in  std_logic;
            Ainvert:    in  std_logic;
            Binvert:    in  std_logic;
            CarryIn:    in  std_logic;
            operation:  in  std_logic_vector (1 downto 0);
            result:     out std_logic;
            CarryOut:   out std_logic
        );
end entity;

architecture stucture of alu_1_bit is
  -- AND2 declaration
 component myAND2
        port (inA,inB: in std_logic; outAND: out std_logic);
 end component;


-- OR2 declaration
  component myOR2          
       port (inA,inB: in std_logic; outOR: out std_logic);
 end component;

-- XOR2 declaration
  component myXOR2          
       port (inA,inB: in std_logic; outXOR: out std_logic);
 end component;

--fulladder declaration
  component fulladder     
            port(CarryIn,inA,inB: in std_logic; sum,CarryOut: out std_logic);
  end component;

--Ainvert declaration
  component notA        
            port(a: in std_logic; Ainvert: in std_logic; inA: out std_logic);
  end component;    

--Binvert declaration
  component notB                
           port(b: in std_logic; Binvert: in std_logic; inB: out std_logic);
  end component;

    

--mux4to1 declaration
    component mux4to1           
            port(outAND, outOR, sum, outXOR: in std_logic; operation: in std_logic_vector(1 downto 0); Result: out std_logic);
    end component;

signal  inA,inB,outAND,outOR,outXOR,sum,outnotA,outnotB :  std_logic; 




begin
u0 : myAND2 port map (inA,inB,outAND); 
u1 : myOR2 port map (inA,inB,outOR); 
u2 : myXOR2 port map (inA,inB,outXOR); 
u3 : fulladder port map (CarryIn,inA,inB,sum,CarryOut); 
u4 : notA port map (a,Ainvert,inA); 
u5 : notB port map (b,Binvert,inB); 
u6 : mux4to1 port map (outAND, outOR,sum, outXOR, operation, Result ); 



end architecture;   


--2 input AND gate
library ieee;
use ieee.std_logic_1164.all;
 entity myAND2 is
     port (inA,inB: in std_logic; outAND: out std_logic);
 end myAND2;
 architecture model1 of myAND2 is
 begin
    outAND<= inA and inB;
 end model1;


 -- 2 input OR gate  
library ieee;
use ieee.std_logic_1164.all;
  entity myOR2 is
        port (inA,inB: in std_logic; outOR: out std_logic);
 end myOR2;
 architecture model2 of myOR2 is
  begin
        outOR <= inA or inB;
 end model2;     


--2 input XOR gate
library ieee;
use ieee.std_logic_1164.all;
    entity myXOR2 is
        port(inA,inB: in std_logic; outXOR: out std_logic);
    end myXOR2;
    architecture model3 of myXOR2 is
    begin 
    outXOR <= inA xor inB;
    end model3;      

--3 input full adder      
library ieee;
use ieee.std_logic_1164.all;
    entity fulladder is
        port(CarryIn,inA,inB: in std_logic; sum,CarryOut: out std_logic);
    end fulladder;
    architecture model4 of fulladder is
    begin
    CarryOut <= (inB and CarryIn) or (inA and CarryIn) or (inA and inB);
    sum <= (inA and not inB and not CarryIn) or (not inA and inB and not CarryIn) or (not inA and not inB and CarryIn) or (inA and inB and CarryIn);
    end model4;

--1 input notA
library ieee;
use ieee.std_logic_1164.all;
    entity notA is
        port(a: in std_logic; Ainvert:std_logic_vector(0 downto 0); inA: out std_logic);
    end notA;
    architecture model5 of notA is
    begin
    with Ainvert select
    inA <=  a when "0",
                        not a when others;
    end model5;

--1 input notB    
library ieee;
use ieee.std_logic_1164.all;
    entity notB is
        port(b: in std_logic; Binvert: std_logic_vector(0 downto 0); inB: out std_logic);
    end notB;
    architecture model6 of notB is
    begin
    with Binvert select
    inB <=  b when "0",
                        not b when others;
    end model6;


--4 input MUX 
library ieee;
use ieee.std_logic_1164.all;
    entity mux4to1 is
        port(outAND, outOR, sum, outXOR: in std_logic; operation: in std_logic_vector(1 downto 0); Result: out std_logic);
    end mux4to1;
    architecture model7 of mux4to1 is
    begin
    with operation select
        Result<= outAND when "00",
                 outOR  when "01",
					  sum    when "10",
                 outXOR when OTHERS;
    end model7 ; 
	 
library ieee;
use ieee.std_logic_1164.all;

--definition of component controlcircuit
entity controlcircuit is
    port (opcode:     in  std_logic_vector(2 downto 0);
          Ainvert:    out std_logic;
          Binvert:    out std_logic;
          operation:  out std_logic_vector(1 downto 0);
          CarryIn:    out std_logic);  -- invert a or b, add + 1 for subtract
end controlcircuit;

architecture Behaviour1 of controlcircuit is
--assignment of outputs dependin on opcode's value
begin
 process(opcode)
 begin
	if (opcode="000") then
		operation<="00";
		Ainvert<='0';
		Binvert<='0';
		CarryIn<='0';
	elsif (opcode="001") then
		operation<="01";
		Ainvert<='0';
		Binvert<='0';
		CarryIn<='0';
	elsif (opcode="010") then
		operation<="10";
		Ainvert<='0';
		Binvert<='0';
		CarryIn<='0';
	elsif (opcode="011") then 
		operation<="10";
		Ainvert<='0';
		Binvert<='1';
		CarryIn<='1';
	elsif (opcode="100") then
		operation<="00";
		Ainvert<='1';
		Binvert<='1';
		CarryIn<='0';
	elsif (opcode="101") then 
		operation<="01";
		Ainvert<='1';
		Binvert<='1';
		CarryIn<='0';
	elsif (opcode="110") then
		operation<="11";
		Ainvert<='0';
		Binvert<='0';
		CarryIn<='0';
	end if;
 end process;	
end Behaviour1;

library ieee;
use ieee.std_logic_1164.all;

-- code for main entity using package basic_components
library work;
use work.basic_components.all;

-- main entity decleration
entity alu16bit is
    port (a:          in  std_logic_vector (15 downto 0);
          b:          in  std_logic_vector (15 downto 0);
          opcode:     in  std_logic_vector (2 downto 0);
          result:     out std_logic_vector (15 downto 0);
			 overflow:   out std_logic);
          
end alu16bit;


--definition of alu16bit
architecture Behaviour3 of alu16bit is
	--package usage
    component controlcircuit is
	 port (opcode:     in  std_logic_vector(2 downto 0);
          Ainvert:    out std_logic;
          Binvert:    out std_logic;
          operation:  out std_logic_vector(1 downto 0);
          CarryIn:    out std_logic);
	 end component;
	 component alu_1_bit is
	 port  ( a:          in  std_logic;
            b:          in  std_logic;
            Ainvert:    in  std_logic;
            Binvert:    in  std_logic;
            CarryIn:    in  std_logic;
            operation:  in  std_logic_vector (1 downto 0);
            result:     out std_logic;
            CarryOut:   out std_logic);
	 end component;
	 
	 signal ainvert:     std_logic;
    signal binvert:     std_logic;
    signal operation:   std_logic_vector (1 downto 0);
    signal carry:       std_logic_vector (16 downto 0);
	 
	 
	 
begin
	--execution of operations for 16bits
   u1 : controlcircuit port map (opcode,ainvert,binvert,operation,carry(0)); 
	My_label: for i in 0 to 15 generate
				stage: alu_1_bit port map (a(i),b(i),ainvert,binvert,carry(i),operation,result(i),carry(i+1));
				
	end generate;
	--control for overflow with the form
	overflow <= carry(15) xor carry(16);
	
end architecture;
