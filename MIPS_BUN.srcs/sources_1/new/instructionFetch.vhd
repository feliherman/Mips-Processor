----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2020 01:55:09 PM
-- Design Name: 
-- Module Name: instructionFetch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity instructionFetch is
    port(
    clk : in STD_LOGIC;
    branch : in STD_LOGIC_VECTOR(15 downto 0);
    jump : in STD_LOGIC_VECTOR(15 downto 0);
    PCSrc : in STD_LOGIC;
    jumpSignal : in STD_LOGIC;
    nextPCAdress : out STD_LOGIC_VECTOR(15 downto 0);
    instruction : out STD_LOGIC_VECTOR(15 downto 0);
    en : in STD_LOGIC;
    reset : in STD_LOGIC
    );
end instructionFetch;

architecture Behavioral of instructionFetch is
type mem_rom is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal rom : mem_rom:=(b"000_000_000_001_0_001", --add $1, %0 ,$0 contor  HEXA : 0011
b"001_000_010_0000101", --addi $2 , @0 , 5  HEXA : 2105
b"000_000_000_101_0_001", --add $5 , $0 , 0   HWXA : 0051
b"000_000_000_011_0_001",-- add $3 , $0 , $0   HEXA 0031
b"100_001_010_0000101", --beq $1 , $2 , end = 10  HEXA 8505
b"010_101_100_0000000", -- lw $4 , ADR($5)      HEXA 5600
b"000_011_100_011_0_001", --add $3 , $3 , $4  HEXA 0E31
b"001_101_101_0000001", --addi $5 , $0 , 1   HEXA 3681
b"001_001_001_0000001", --addi $1, $1 ,1  HEXA 2481
b"111_0000000000100", -- j loop = 4  HEXA E004
b"011_000_011_0000010", -- end : sw #3 sum_adr($0)    HEXA6182
 others => x"1111");

signal PC : STD_LOGIC_VECTOR(15 downto 0 ) := x"0000";
signal PCURM : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal m1 : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal m2 : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal auxB : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
begin
 process(clk, reset)
 begin
    if reset = '1' then
        PC <= x"0000";
    else
        if clk = '1' and clk'event then
            if en ='1' then
                PC <= m2;
             end if;
         end if;
     end if;
 end process;
 instruction <= rom(conv_integer(PC(4 downto 0)));
 PCURM <= PC+x"0001";
 nextPCAdress <= PCURM;  
  process(PCSrc)
  begin
    case PCSrc is
        when '1' => m1 <= branch;
        when others => m1 <= PCURM;
     end case;
  end process;
  
  process(jumpSignal)
  begin
      case jumpSignal is
          when '1' => m2 <=jump;
          when others => m2 <= m1;
       end case;
    end process;
end Behavioral;
