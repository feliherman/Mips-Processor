----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2020 01:46:51 PM
-- Design Name: 
-- Module Name: instructionDecoder - Behavioral
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

entity instructionDecoder is
    port(
        MPG_Enable : in STD_LOGIC;
        clk : in STD_LOGIC;
        RegWrite : in STD_LOGIC;
        RegDst : in STD_LOGIC;
        ExtOp : in STD_LOGIC;
        Instr : in STD_LOGIC_VECTOR(15 downto 0);
        RD1 : OUT STD_LOGIC_VECTOR(15 downto 0);
        RD2 : out STD_LOGIC_VECTOR(15 downto 0);
        WD : in STD_LOGIC_VECTOR(15 downto 0);
        Ext_Imm : out STD_LOGIC_VECTOR(15 downto 0);
        sa : out STD_LOGIC;
        func : out STD_LOGIC_VECTOR(2 downto 0) 
        
    );
end instructionDecoder;

architecture Behavioral of instructionDecoder is
component regfile is
    port(
        clk : in STD_LOGIC;
        ra1 : in STD_LOGIC_VECTOR(2 downto 0);
        ra2: in STD_LOGIC_VECTOR(2 downto 0);
        wa : in STD_LOGIC_VECTOR(2 downto 0);
        wd : in STD_LOGIC_VECTOR(15 downto 0);
        rd1 : out STD_LOGIC_VECTOR(15 downto 0);
        rd2 : out STD_LOGIC_VECTOR(15 downto 0);
        wen : in STD_LOGIC
        );
end component;
signal WriteAdress : STD_LOGIC_VECTOR(2 downto 0);
Signal RegWrite1 : STD_LOGIC;
begin
    RegWrite1 <= RegWrite and MPG_Enable;
    RF : regfile port map (clk, Instr(12 downto 10),Instr(9 downto 7),WriteAdress,WD,RD1, RD2,RegWrite1);
process(RegDst)
begin  
case RegDst is
    when '0' => WriteAdress <= Instr(9 downto 7);
    when '1' => WriteAdress <= Instr(6 downto 4);
end case;   
end process;

func <= Instr(2 downto 0);
sa <= Instr(3);

process(ExtOp)
begin
case ExtOp is
    when '0' => Ext_Imm<= "000000000" & Instr(6 downto 0);
    when '1' => if(instr(6) = '0') then Ext_Imm <= "000000000" &Instr(6 downto 0);
                else
                    Ext_Imm <= "111111111" & Instr( 6 downto 0);
                 end if;
end case;
end process;
end Behavioral;
