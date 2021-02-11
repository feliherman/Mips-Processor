library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity afisare_SSD is
port (
    Digit0 :in STD_LOGIC_VECTOR(3 downto 0);
    Digit1 : in STD_LOGIC_VECTOR(3 downto 0);
    Digit2: in STD_LOGIC_VECTOR(3 downto 0);
    Digit3 : in STD_LOGIC_VECTOR(3 downto 0);
    clk : in STD_LOGIC;
    CAT : out STD_LOGIC_VECTOR(6 downto 0);
    AN : out STD_LOGIC_VECTOR(3 downto 0)

);
end afisare_SSD;

architecture Behavioral of afisare_SSD is
signal data : STD_LOGIC_VECTOR(15 downto 0);
signal data1 : STD_LOGIC_VECTOR(1 downto 0);
signal outmux1 : STD_LOGIC_VECTOR(3 downto 0);
begin

process(clk)
    begin
    if rising_edge(clk) then
                data<=data+1;
           end if;
end process;
data1 <= data(15 downto 14);
process(data1, Digit0, Digit1, Digit2, Digit3)
begin
case data1 is
    when "00" =>outmux1 <=Digit0;
    when "01" =>outmux1 <= Digit1;
    when "10" => outmux1 <= Digit2;
    when "11" => outmux1 <= Digit3;
   end case;
end process;


process(data1)
begin
case data1 is
    when "00" =>AN <="0111";
    when "01" =>AN <="1011";
    when "10" =>AN <="1101";
    when "11" =>AN <="1110";
   end case;
end process;


    with outmux1 SELect
   CAT<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0


				
				
end Behavioral;
