library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity source is
generic( N : integer := 10);
Port (
a : in unsigned( N-1 downto 0);
tvalid : in std_logic;
tlast : in std_logic;
clk : in std_logic;
result : out unsigned(N-1 downto 0);
out_valid : out std_logic := '0'
);
end source;

architecture Behavioral of source is

signal b : unsigned(N-1 downto 0);
signal x : unsigned(N-1 downto 0);
type tp is (first, second, last);
signal step: tp := first;

begin
    result <= b;      
    process(clk) is
    
    variable tmp : std_logic_vector( 2 * N - 1 downto 0);
    begin
    if (clk'event) and (clk = '1') and tvalid = '1'then
        case step is
        when first =>
            x <= a;
            b <= to_unsigned(0,N);  
            out_valid <= '0';  
            step <= second;
        when second =>
            b <= a;
            tmp := std_logic_vector(resize(a, 2*N));
            step <= last;
        when last =>
            tmp := std_logic_vector(b * x + a);
            b <= unsigned(tmp(N - 1 downto 0));
        end case;
        if (tlast = '1') then
            step <= first;
            out_valid <= '1';  
        end if;
end if;  
end process;
end Behavioral;
