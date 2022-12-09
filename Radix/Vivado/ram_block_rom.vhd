-- (adapted from) Listing 11.5
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ram_block_rom is
   port(
      addr: in std_logic_vector(2 downto 0);
      data: out std_logic_vector(2 downto 0)
   );
end ram_block_rom;

architecture arch of ram_block_rom is
   --constant ADDR_WIDTH: integer:=5;
   --constant DATA_WIDTH: integer:=8;
   type rom_type is array (0 to 7)
        of std_logic_vector(2 downto 0);
   -- ROM definition
   
   constant ram_addresses: rom_type:=(
        "000", -- 0 addr: ram0
        "001", -- 1 addr: ram1
        "010", -- 2 addr: ram2
        "011", -- 3 addr: ram3
        "100", -- 4 addr: ram4
        "101", -- 5 addr: ram5
        "110", -- 6 addr: ram6
        "111"  -- 7 addr: ram7
   );
--   constant HEX2LED_ROM: rom_type:=(  -- jeanjacquesrousseau
--      x"6A",  -- addr 00: j
--      x"65",  -- addr 01: e
--      x"61",  -- addr 02: a
--      x"6E",  -- addr 03: n
--      x"6A",  -- addr 04: j
--      x"61",  -- addr 05: a
--      x"63",  -- addr 06: c
--      x"71",  -- addr 07: q
--      x"75",  -- addr 08: u
--      x"65",  -- addr 09: e
--      x"73",  -- addr 10: s
--      x"72",  -- addr 11: r
--      x"6F",  -- addr 12: o
--      x"75",  -- addr 13: u
--      x"73",  -- addr 14: s
--      x"73",  -- addr 15: s
--	  x"65",  -- addr 16: e
--	  x"61",  -- addr 17: a
--	  x"75",  -- addr 18: u
--	  x"FF",  -- addr 19: (void)
--	  x"FF",  -- addr 20: (void)
--	  x"FF",  -- addr 21: (void)
--	  x"FF",  -- addr 22: (void)
--	  x"FF",  -- addr 23: (void)
--	  x"FF",  -- addr 24: (void)
--	  x"FF",  -- addr 25: (void)
--	  x"FF",  -- addr 26: (void)
--	  x"FF",  -- addr 27: (void)
--	  x"FF",  -- addr 28: (void)
--	  x"FF",  -- addr 29: (void)
--	  x"FF",  -- addr 30: (void)
--	  x"FF"   -- addr 31: (void)
--   );
begin
   data <= addr; 
   --data <= HEX2LED_ROM(to_integer(unsigned(addr)));
end arch;