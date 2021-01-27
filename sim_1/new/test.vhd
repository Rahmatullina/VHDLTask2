library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test is end entity;

architecture Behavioral of test is
constant N : integer range 0 to 10 := 5;
constant degree : integer range 0 to 10 := 2;
signal a : unsigned (N - 1 downto 0);
signal tlast : std_logic := '0';
signal tvalid : std_logic := '0';
signal clk : std_logic := '1';
signal result : unsigned (N - 1 downto 0);
signal out_valid : std_logic;
signal targetResult : unsigned (N - 1 downto 0);

type arr is array(degree downto 0) of unsigned(N - 1 downto 0);
signal massive: arr;
signal x : unsigned(N - 1 downto 0);

procedure delay(signal clk : in std_logic) is 
begin
    wait until clk'event and clk = '1';
end delay;

procedure evalFunc(signal clk : in std_logic; 
                   signal massive: in arr; 
                   variable x0 : in unsigned(N - 1 downto 0);
                   signal result : out unsigned(N-1 downto 0)
                   ) is 
             
    variable tmp : std_logic_vector( N - 1 downto 0);
    variable tmp2 : std_logic_vector( N downto 0);
    variable compnnt : std_logic_vector(((degree + 1) * N) - 1 downto 0);
    variable poweredX : unsigned( (degree * N) - 1 downto 0);
    variable arrvar : unsigned(N - 1 downto 0);
    begin  
    tmp := std_logic_vector(to_unsigned(0, N));  
       for i in 0 to degree - 1 loop
           poweredX := to_unsigned(1, (degree * N));
            for j in i to degree - 1 loop
                poweredX := resize(poweredX * x0, (degree * N));
            end loop;
            arrvar := massive(i);
            compnnt := std_logic_vector(arrvar * poweredX); 
            tmp := std_logic_vector(unsigned(tmp) + unsigned(compnnt(N - 1 downto 0 )));
       end loop;
       arrvar := massive(degree);
        tmp := std_logic_vector(unsigned(tmp) + arrvar);
        result <= unsigned(tmp);
    end evalFunc;

begin

 DUT : entity work.source generic map (N  => N) port map(a => a, tvalid => tvalid, tlast => tlast, clk => clk, result => result, out_valid => out_valid);
 process is 
 
  variable res : unsigned(N - 1 downto 0);
  variable tmpX0 : unsigned(N - 1 downto 0);
  
begin
    for i in 1 to 31 loop
      for j in 1 to 31 loop
       for k in 1 to 31 loop
        for x0 in 3 to 4 loop
            massive(0) <= to_unsigned(i, N);
            massive(1) <= to_unsigned(j, N);
            massive(2) <= to_unsigned(k, N);
   
            wait for 5 ns;
            delay(clk);
            a <= to_unsigned(x0, N);
            tlast <= '0';
            tvalid <= '1';
            delay(clk);
            if out_valid = '1' then 
                assert targetResult = result  report "FAILURE : result != target";
            end if;
            a <= to_unsigned(i, N);
            tlast <= '0';
            delay(clk);
            a <= to_unsigned(j, N);
            tlast <= '0';
            delay(clk);
            a <= to_unsigned(k, N);
            tlast <= '1';
            tmpX0 := to_unsigned(x0, N);
            evalFunc(clk, massive, tmpX0, targetResult);
            x <= tmpX0;
          end loop;
          end loop;
          end loop;
          end loop;    
 end process;
 
    process is 
    begin 
        clk <= not clk;
        wait for 5ns;
    end process;
 
end Behavioral;
