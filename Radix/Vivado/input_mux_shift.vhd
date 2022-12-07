-- Listing 4.13
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity input_mux_shift is
   port(
      clk, reset: in std_logic;
      in1, in0: in std_logic_vector(7 downto 0);
   --   an: out std_logic_vector(3 downto 0);
      sseg: out std_logic_vector(7 downto 0)
   );
end input_mux_shift;

architecture arch of input_mux_shift is
   -- refreshing rate around 800 Hz (50MHz/2^16)
   constant N: integer:=18;
   signal q_reg, q_next: unsigned(N-1 downto 0);
   signal sel: std_logic;
begin
   -- register
   process(clk,reset)
   begin
      if reset='1' then
         q_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         q_reg <= q_next;
      end if;
   end process;

   -- next-state logic for the counter
   q_next <= q_reg + 1;

   -- 2 MSBs of counter to control 4-to-1 multiplexing
   -- and to generate active-low enable signal
   process(sel,in0,in1)
   begin
      case sel is
         when '0' =>
            --an <= "1110";
            sseg <= in0;
         when '1' =>
           -- an <= "1101";
            sseg <= in1;
      end case;
   end process;
end arch;