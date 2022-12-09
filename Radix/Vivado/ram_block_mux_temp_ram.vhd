-- Listing 4.13
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ram_block_mux_temp_ram is
   port(
      clk, reset: in std_logic;
      sel: std_logic_vector(2 downto 0);
      in0: in std_logic_vector(7 downto 0);
      in1: in std_logic_vector(7 downto 0);
      in2: in std_logic_vector(7 downto 0);
      in3: in std_logic_vector(7 downto 0);
      in4: in std_logic_vector(7 downto 0);
      in5: in std_logic_vector(7 downto 0);
      in6: in std_logic_vector(7 downto 0);
      in7: in std_logic_vector(7 downto 0);
      out0:out std_logic_vector(7 downto 0)
   );
end ram_block_mux_temp_ram;

architecture arch of ram_block_mux_temp_ram is
   -- refreshing rate around 800 Hz (50MHz/2^16)
   constant N: integer:=18;
   signal q_reg, q_next: unsigned(N-1 downto 0);
   --signal sel: std_logic_vector(2 downto 0);
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
   process(sel,in0,in1,in2,in3,in4,in5,in6,in7)
   begin
      case sel is
        when "000" =>
            out0 <= in0;
        when "001" =>
            out0 <= in1;
        when "010" =>
            out0 <= in2;
        when "011" =>
            out0 <= in3;
        when "100" =>
            out0 <= in4;
        when "101" =>
            out0 <= in5;
        when "110" =>
            out0 <= in6;
        when "111" =>
            out0 <= in7;
      end case;
   end process;
end arch;