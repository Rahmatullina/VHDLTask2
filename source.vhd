library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity source is
generic( N : integer := 10);
Port (
a : in integer range 0 to to_integer(shift_left(to_unsigned(1, N + 1),N));
tvalid : in std_logic;
tlast : in std_logic;
clk : in std_logic;
result : out integer range 0 to to_integer(shift_left(to_unsigned(1, N + 1),N)) ;
out_valid : out std_logic
);
end source;

architecture Behavioral of source is
constant MaxVal : integer := to_integer(shift_left(to_unsigned(1, N + 1),N));
signal b : integer range 0 to MaxVal := 0;
signal x : integer range 0 to MaxVal := 0;


type tp is (first, second, rest);
signal step: tp := first;
begin
result <= b;  
process(clk)is
begin

if (clk'event) and (clk = '1') and tvalid = '1'then
    case step is
    when first =>
        x <= a;
        b <= 0;  
        out_valid <= '0';  
        step <= second;
    when second =>
        b <= a;
        step <= rest;
    when rest =>
        if ( MaxVal - (b * x + a) > b) then
            b <= (b * x + a);
        else 
            b <= (b * x + a - MaxVal);
        end if;
end case;
if (tlast = '1') then
    step <= first;
    out_valid <= '1';  
end if;
end if;  
end process;
end Behavioral;
