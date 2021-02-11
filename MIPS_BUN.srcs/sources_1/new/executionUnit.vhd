----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2020 01:00:54 PM
-- Design Name: 
-- Module Name: executionUnit - Behavioral
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


--use UNISIM.VComponents.all;

entity executionUnit is
    port(
        RD1 : in STD_LOGIC_VECTOR(15 downto 0);
        RD2 : in STD_LOGIC_VECTOR(15 downto 0);
        Ext_Imm : in STD_LOGIC_VECTOR(15 downto 0);
        ALUSrc : in STD_LOGIC;
        sa : in STD_LOGIC;
        func : in STD_LOGIC_VECTOR(2 downto 0);
        AluOP : in STD_LOGIC_VECTOR(2 downto 0);
        Zero : out STD_LOGIC;
       ALURes : out STD_LOGIC_VECTOR(15 downto 0);
       GEZero : out STD_LOGIC
    );
end executionUnit;

architecture Behavioral of executionUnit is
signal aux : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal alu2In : STD_LOGIC_VECTOR(15 downto 0 ) := x"0000";

begin



process
begin
    case ALUSrc is
        when '0' => alu2In <= RD2 ;
        when '1' => alu2In <= Ext_Imm;
        when others => alu2In <= x"0000";
    end case;
end process; 



process
begin
  case AluOp is
        when "000" => 
            case func is
                when "001" => aux <= RD1 + alu2In;
                when "010" =>aux <= RD1 - alu2In;
                when "011" => if sa = '0' then 
                                aux <= RD1;
                              else
                                aux<= RD1(14 downto 0) & '0';
                              end if;
                when "100" => if sa = '0' then
                                 aux <= RD1;
                              else
                                 aux<= '0' & RD1(15 downto 1);
                              end if;
                when "101" => aux <= RD1 and alu2In;
                when "110" => aux<= RD1 or alu2In;
                when "111" => aux<= RD1 xor alu2In;
                when "000" => case RD1 is
                                when x"0001" => aux <= alu2In(14 downto 0) & '0';
                                when x"0002" => aux <= alu2In(13 downto 0) & "00";
                                when x"0003" => aux <= alu2In(12 downto 0) & "000";
                                when others => aux <= alu2In;
                               end case;
             when others => aux <= x"0000";
             end case;
                
      when "001"=> aux <= RD1 + alu2In;
      when "010" => aux <= RD1 + alu2In;
      when "011" => aux <= RD1 + alu2In;  
      when "100" => aux <= RD1 - alu2In;
      when "101" => if RD1 > 0 then
                        GEZero <= '1';
                    else
                        GEZero <= '0';
                    end if;
                        
      when "110" => if (RD1 - alu2In) < 0 then
                        aux<=x"0001";
                    else
                        aux <= x"0000"; 
                    end if;
      when "111" => aux <=x"0000";
     end case;
end process;

process
begin
    case aux is
        when x"0000" => Zero <= '1';
        when others => Zero <= '0';
    end case;
end process;
 ALURes <= aux;
end Behavioral;
