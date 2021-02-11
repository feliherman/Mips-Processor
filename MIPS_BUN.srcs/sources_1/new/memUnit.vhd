
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity memUnit is
    port(
        MemWrite : in STD_LOGIC;
        MpgEnable : in STD_LOGIC;
        clk : in STD_LOGIC;
        ALUIn : in STD_LOGIC_VECTOR ( 15 downto 0);
        RD2 : in STD_LOGIC_VECTOR(15 downto 0);
        MemData : out STD_LOGIC_VECTOR(15 downto 0);
        ALURes : out STD_LOGIC_VECTOR(15 downto 0)    
        );
end memUnit;

architecture Behavioral of memUnit is
type Mem is array (0 to 63) of STD_LOGIC_VECTOR(15 downto 0);
signal Memory : Mem := (x"0001", x"0005",x"000C",x"0030", x"0004" , others => x"0000");

begin

process(clk)
    begin 
        if rising_edge(clk) then
            if MpgEnable = '1' then
                if MemWrite ='1' then
                    Memory(conv_integer(ALUIn(5 downto 0))) <= RD2;
                end if;
            end if;
        end if;
       
end process;
    MemData <= Memory(conv_integer(ALUIn(5 downto 0)));
    ALURes <= ALUIn;            

end Behavioral;
