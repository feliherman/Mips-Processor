
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity writeBack is
    port(
        MemToReg : in STD_LOGIC;
        WriteData : out STD_LOGIC_VECTOR(15 downto 0);
        ReadData1 : in STD_LOGIC_VECTOR(15 downto 0);
        ReadData2 : in STD_LOGIC_VECTOR(15 downto 0);
        BEQ : in STD_LOGIC;
        Zero : in STD_LOGIC;
        BGEZ : in STD_LOGIC;
        GEZero : in STD_LOGIC;
        PCSrc : out STD_LOGIC
    );
end writeBack;

architecture Behavioral of writeBack is

begin
    process(MemToReg)
        begin 
            case MemToReg is
                when '1' => WriteData <= ReadData1;
                when '0' => WriteData <= ReadData2;
            end case;
    end process;
    
    PCSrc <= (BEQ and Zero) or (GEZero and GEZero);

end Behavioral;
