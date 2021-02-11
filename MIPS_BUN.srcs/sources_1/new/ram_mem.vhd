----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2020 10:36:14 AM
-- Design Name: 
-- Module Name: ram_mem - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_mem is
    port(
        clk : in STD_LOGIC;
        ra1 : in STD_LOGIC_VECTOR(3 downto 0);
        ra2: in STD_LOGIC_VECTOR(3 downto 0);
        wa : in STD_LOGIC_VECTOR(3 downto 0);
        wd : in STD_LOGIC_VECTOR(15 downto 0);
        rd1 : out STD_LOGIC_VECTOR(15 downto 0);
        rd2 : out STD_LOGIC_VECTOR(15 downto 0);
        wen : in STD_LOGIC
        );
end ram_mem;

architecture Behavioral of ram_mem is
type reg_mem is array(0 to 255) of std_logic_vector(15 downto 0);
signal memreg : reg_mem:=(x"0000", x"0001", x"0010", x"0100",others=>x"0000") ;
begin
process(clk)
    begin
    if rising_edge(clk) then 
        if wen = '1' then
            memreg(conv_integer(wa))<=wd;
        end if;
    end if;
end process;
rd1<=memreg(conv_integer(ra1))(15 downto 2) & "00";
end Behavioral;
