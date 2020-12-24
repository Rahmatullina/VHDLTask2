library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test is end entity;

architecture Behavioral of test is

signal a : integer range 0 to 32 := 0;
signal tlast : std_logic := '0';
signal tvalid : std_logic := '0';
signal clk : std_logic := '0';
signal result : integer range 0 to 80;
signal out_valid : std_logic;
procedure delay(signal clk : in std_logic) is 
begin
    wait until clk'event and clk = '1';
end delay;

begin

 DUT : entity work.source generic map (N  => 4) port map(a => a, tvalid => tvalid, tlast => tlast, clk => clk, result => result, out_valid => out_valid);
 
 process is 
 begin
 wait for 5 ns;
 delay(clk);
    a <= 3;
    tlast <= '0';
    tvalid <= '1';
    delay(clk);
    a <= 2;
    tlast <= '0';
    delay(clk);
    a <= 3;
    tlast <= '0';
    delay(clk);
    a <= 4;
    tlast <= '1';
 end process;
 
 process is 
 begin 
 clk <= not clk;
 wait for 5ns;
 end process;
 
end Behavioral;
