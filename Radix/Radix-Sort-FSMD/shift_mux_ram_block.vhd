-- Listing 4.13
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity shift_mux_ram_block is
   port(
      clk, reset: in std_logic;
      sel: in std_logic_vector(2 downto 0);
      in0: in std_logic_vector(7 downto 0);
      out0: out std_logic_vector(7 downto 0);
      out1: out std_logic_vector(7 downto 0);
      out2: out std_logic_vector(7 downto 0);
      out3: out std_logic_vector(7 downto 0);
      out4: out std_logic_vector(7 downto 0);
      out5: out std_logic_vector(7 downto 0);
      out6: out std_logic_vector(7 downto 0);
      out7: out std_logic_vector(7 downto 0)
   );
end shift_mux_ram_block;

architecture arch of shift_mux_ram_block is
   -- refreshing rate around 800 Hz (50MHz/2^16)
   constant N: integer:=18;
   signal q_reg, q_next: unsigned(N-1 downto 0);
--   signal sel: std_logic_vector(2 downto 0);
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
   process(sel,in0)
   begin
      case sel is
        when "000" =>
            out0 <= in0;
        when "001" =>
            out1 <= in0;
        when "010" =>
            out2 <= in0;
        when "011" =>
            out3 <= in0;
        when "100" =>
            out4 <= in0;
        when "101" =>
            out5 <= in0;
        when "110" =>
            out6 <= in0;
        when "111" =>
            out7 <= in0;
      end case;
   end process;
end arch;