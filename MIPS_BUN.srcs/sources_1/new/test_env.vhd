


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env is
   port(
   clk : in STD_LOGIC;
   btn : in STD_LOGIC_VECTOR(3 downto 0);
   sw : in STD_LOGIC_VECTOR(15 downto 0);
   led : out STD_LOGIC_VECTOR(15 downto 0);
   an : out STD_LOGIC_VECTOR(3 downto 0);
   cat : out STD_LOGIC_VECTOR(6 downto 0)
   );
end test_env;





architecture Behavioral of test_env is
type memt is array(0 to 255) of std_logic_vector(15 downto 0);
signal memrom : memt:=(b"001_000_010_0000010", b"001_000_011_0000100", b"000_010_011_100_0_001", b"110_100_001_0000000",others=>x"0000");
component MPG is
port (
             en : out  STD_LOGIC;
           input : in STD_LOGIC;   
           clock : in  STD_LOGIC); 
end component;
component afisare_SSD is
port (
    Digit0 :in STD_LOGIC_VECTOR(3 downto 0);
    Digit1 : in STD_LOGIC_VECTOR(3 downto 0);
    Digit2: in STD_LOGIC_VECTOR(3 downto 0);
    Digit3 : in STD_LOGIC_VECTOR(3 downto 0);
    clk : in STD_LOGIC;
    CAT : out STD_LOGIC_VECTOR(6 downto 0);
    AN : out STD_LOGIC_VECTOR(3 downto 0)

);
end component;
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
component ram_mem is
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
end component;
component instructionFetch is
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
end component;

component instructionDecoder is
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
end component;
component ControlUnit is
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
end component;

component executionUnit is
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
end component;

component memUnit is
    port(
        MemWrite : in STD_LOGIC;
        MpgEnable : in STD_LOGIC;
        clk : in STD_LOGIC;
        ALUIn : in STD_LOGIC_VECTOR ( 15 downto 0);
        RD2 : in STD_LOGIC_VECTOR(15 downto 0);
        MemData : out STD_LOGIC_VECTOR(15 downto 0);
        ALURes : out STD_LOGIC_VECTOR(15 downto 0)    
        );
end component;

signal data : STD_LOGIC_VECTOR(15 downto 0);
signal en: STD_LOGIC := '0';
signal en1: STD_LOGIC := '0';
signal data1 : STD_LOGIC_VECTOR(3 downto 0);
signal data2: STD_LOGIC_VECTOR(15 downto 0);
signal rez1: STD_LOGIC_VECTOR(15 downto 0);
signal rez2: STD_LOGIC_VECTOR(15 downto 0);
signal sum : STD_LOGIC_VECTOR(15 downto 0);
signal branch_adr : STD_LOGIC_VECTOR(15 downto 0):=x"0001";
signal jump_adr : STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal instruction : STD_LOGIC_VECTOR(15 downto 0);
signal next_adress : STD_LOGIC_VECTOR(15 downto 0);
signal aux : STD_LOGIC_VECTOR(15 downto 0);
signal RegWrite : STD_LOGIC;
signal RegDst : STD_LOGIC;
signal ExtOp : STD_LOGIC;
signal ReadAdress1 : STD_LOGIC_VECTOR(15 downto 0);
signal ReadAdress2 : STD_LOGIC_VECTOR(15 downto 0);
signal WD : STD_LOGIC_VECTOR(15 downto 0);
signal ext_imm : STD_LOGIC_VECTOR(15 downto 0);
signal sa : STD_LOGIC;
signal func : STD_LOGIC_VECTOR(2 downto 0);
signal OpCode : STD_LOGIC_VECTOR(2 downto 0);
signal AluSrc : STD_LOGIC;
signal Branch : STD_LOGIC;
signal Jump :STD_LOGIC;
signal ALUOP : STD_LOGIC_VECTOR(2 downto 0);
signal MemWrite : STD_LOGIC;
signal MemToReg : STD_LOGIC;
signal WDsum : STD_LOGIC_VECTOR(15 downto 0);
signal Zero : STD_LOGIC;
signal GEZero : STD_LOGIC;
signal AluRes : STD_LOGIC_VECTOR(15 downto 0);
signal MemData : STD_LOGIC_VECTOR(15 downto 0);
signal AluOut : STD_LOGIC_VECTOR(15 downto 0);
signal PCSrc : STD_LOGIC;
begin


branch_adr <= ext_imm + next_adress;
jump_adr <= next_adress(15 downto 13) & instruction(12 downto 0); 
firstMPG : MPG port map(en,btn(0),clk);
secondMPG : MPG port map(en1,btn(1),clk);
afisare : afisare_SSD port map(aux(15 downto 12), aux(11 downto 8),aux(7 downto 4),aux(3 downto 0),clk,cat,an);
--ceva2 : regfile port map(clk,data1,data1,data1,sum,rez1,rez2,en);
--ceva3 : ram_mem port map(clk,data1,data1,data1,sum,rez1,rez2,en);
instrFet : instructionFetch port map(clk,branch_adr,jump_adr,PCSrc,Jump,next_adress,instruction,en,en1);
instrDec : instructionDecoder port map(en,clk,RegWrite,RegDst,ExtOp,instruction,ReadAdress1,ReadAdress2,WD,ext_imm,sa,func);
unitControl : ControlUnit port map(instruction(15 downto 13),RegDst,ExtOp,AluSrc,Branch, Jump, ALUOP,MemWrite, MemToReg, RegWrite);
exUnit : executionUnit port map(ReadAdress1, ReadAdress2,ext_imm, AluSrc, sa, func, ALUOP, Zero ,AluRes, GEZero );
memory : memUnit port map (MemWrite, en, clk, AluRes, ReadAdress2, MemData,AluOut );

 process(MemToReg)
        begin 
            case MemToReg is
                when '0' => WD <= AluOut;
                when '1' => WD <= MemData;
            end case;
    end process;
    
PCSrc <= (Branch and Zero) or (Branch and GEZero);
--WDsum <= ReadAdress1 + ReadAdress2;
process(sw(7 downto 5))
begin
case sw(7 downto 5) is
    when "000" => aux <= instruction;
    when "001" => aux<=next_adress;
    when "010" => aux <=ReadAdress1;
    when "011" => aux <= ReadAdress2;
    when "100" => aux <= ext_imm;
    when "101" => aux <= AluRes;
    when "110" => aux <= MemData;
    when "111" => aux <= WD;
end case;
end process;
    led(15) <= RegDst;
    led(14) <= ExtOp;
    led(13)  <= AluSrc;
    led(12) <= Zero;
    led(11) <= Branch;
    led(10) <= Jump;
    led(9) <= PCSrc;
    led(8) <= MemWrite;
    led(7) <=MemToReg;
    led(6) <= RegWrite;
    led(5) <= GEZero;
    led(2)<=instruction(6);
    led(1) <= instruction(5);
    led(0) <= instruction(4);
--process(sw(7))
--begin
--    if(sw(7) = '1') then
--       aux<=next_adress;
--    else
--        aux <= instruction;
--      end if;
--end process; 
--process(clk)
--    begin
--    if rising_edge(clk) then
--        if en='1' then
--            if sw(0)='1' then
--                data<=data+1;
--            else
--                data<=data-1;
--           end if;
--          end if;
--         end if;
--    --led(0)<=data1(0);
--    --led(1)<=data1(1);
--end process;
--data1<=data(3 downto 0);

--data1<=data(7 downto 0);
--data1<=data(1 downto 0);

--process( sw(4 downto 1), sw(8 downto 5), sw(8 downto 1),data1)

--begin
--case data1 is
--    when "00" => data2 <=x"000" & (sw(4 downto 1) + sw(8 downto 5));
--    when "01" => data2 <=x"000" & (sw(4 downto 1) - sw(8 downto 5));
--    when "10" => data2 <= x"000" & sw(4 downto 1);
--    when "11" => data2 <= sw(4 downto 1) & x"000";
--end case; 
--    if(data2=x"0000") then
--        led(7) <= '1';
--    else
--        led(7)<='0';
--     end if;
        
--end process;
--led<=memrom(conv_integer(data1));
--sum<=rez1+rez2;
end Behavioral;



