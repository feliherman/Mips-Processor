----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2020 03:04:09 PM
-- Design Name: 
-- Module Name: ControlUnit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit is
    port(
        OpCode : in STD_LOGIC_VECTOR(2 downto 0);
        RegDst : out STD_LOGIC;
        ExtOp : out STD_LOGIC;
        AluSrc : out STD_LOGIC;
        Branch : out STD_LOGIC;
        Jump : out STD_LOGIC;
        ALUOP: out STD_LOGIC_VECTOR(2 downto 0);
        MemWrite : out STD_LOGIC;
        MemToReg : out STD_LOGIC;
        RegWrite : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is

begin
process(OpCode)
begin
    RegDst <= '0'; ExtOp <= '0'; AluSrc <= '0'; Branch <= '0'; Jump <='0';ALUOP <= "000";MemWrite <= '0'; MemToReg <= '0' ; RegWrite <= '0';
    case OpCode is
        when "000" => RegWrite <= '1';RegDst<='1';
        when "001" => RegWrite <='1'; AluSrc <='1'; ExtOp <= '1' ;ALUOP <= "001"; --addi
        when "010" => RegWrite <= '1' ; AluSrc<='1'; ExtOp <= '1'; MemToReg <= '1';ALUOP<="001";--lw
        when "011" => AluSrc <= '1' ; ExtOp <= '1'; MemWrite<='1';ALUOP<="001"; --sw
        when "100" => ExtOp <= '1' ; ALUOP <="100" ; Branch<='1'; --beq
        when "101" => AluSrc<='1';ALUOP<="101";Branch<='1';--bgez
        when "110" => AluSrc <= '1'; ALUOP <= "010";--slti
        when "111" => Jump<='1';ALUOP <= "111";--jump
     end case;
end process;
end Behavioral;
