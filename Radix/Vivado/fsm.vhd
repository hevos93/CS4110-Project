-- (adapted from) Listing 5.1
library ieee;
use ieee.std_logic_1164.all;
entity ctr_path is
   port(
      -- Board Controls
      clk, reset: in std_logic;

	  ascii_r, ascii_t: in std_logic_vector(7 downto 0);
      -- This is to be removed
      clra_rom, inca_rom, clrb_ram, incb_ram, wr: out std_logic;
      
      -- Reciever
      rx_done: in std_logic;
      
      -- Input RAM counter
      input_ram_counter_clr, input_ram_counter_inc: out std_logic;
      
      -- Input RAM
      input_ram_wr:out std_logic;
      
      -- Input MUX
      input_mux_switch: out std_logic;
      
      -- ROM for the shift values (SHIFT ROM)
      shift_rom_counter_clr, shift_rom_counter_inc: out std_logic;
      
      -- RAM BLOCK
      ram0_wr, ram1_wr, ram2_wr, ram3_wr, ram4_wr, ram5_wr, ram6_wr, ram7_wr: out std_logic;
      ram0_counter_clr, ram1_counter_clr, ram2_counter_clr, ram3_counter_clr, ram4_counter_clr, ram5_counter_clr, ram6_counter_clr, ram7_counter_clr: out std_logic;
      ram0_counter_inc, ram1_counter_inc, ram2_counter_inc, ram3_counter_inc, ram4_counter_inc, ram5_counter_inc, ram6_counter_inc, ram7_counter_inc: out std_logic;
      
      -- ROM after RAM BLOCK before temp RAM
      ram_block_rom_counter_clr, ram_block_rom_counter_inc: out std_logic;
           
     -- Temp RAM Counter
      temp_ram_counter_clr, temp_ram_counter_inc: out std_logic;
      
      -- Temp RAM
      temp_ram_wr: out std_logic;
      
      -- Output RAM counter
      output_ram_counter_clr, output_ram_counter_inc: out std_logic;
      
      -- Output RAM
      output_ram_wr: out std_logic;
      
      -- Transmitter
      tx_start: out std_logic;
      tx_done: in std_logic
      
   );
end ctr_path;

architecture arch of ctr_path is
   type state_type is (s0, s1, s2, s3);
   signal state_reg, state_next: state_type;
begin

   -- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= s0;
      elsif rising_edge(clk) then
         state_reg <= state_next;
      end if;
   end process;
   
   -- next-state and outputs logic
   process(state_reg, rx_done, tx_done, ascii_r, ascii_t)
   begin
   clra_rom <= '0';
   inca_rom <= '0';
   clrb_ram <= '0';
   incb_ram <= '0';
   wr <= '0';
   tx_start <= '0';
   state_next <= state_reg;
   
      case state_reg is
         when s0 =>
            clra_rom <= '1';
			clrb_ram <= '1';
            state_next <= s1;
         when s1 =>
            if (rx_done='1') then
			   if ((ascii_r >= x"41" and ascii_r <= x"5A") or 
			       (ascii_r >= x"61" and ascii_r <= x"7A") or 
			           ascii_r = x"20" or ascii_r = x"0D") then
                  wr <= '1';
                  
--                  if (ascii_r = x"20") then   -- Space key?
--                     incb_ram <= '1';
--                     state_next <= s1;
--                  else
                  
				  if (ascii_r=x"0D") then  -- Enter key?
				     clrb_ram <= '1';
					 state_next <= s2;
				  else
				     inca_rom <= '1';
					 incb_ram <= '1';
				  end if;
				  
--				  end if;
				  
               end if;
			end if;
         when s2 =>
            if (ascii_t=x"0D") then 
			   state_next <= s0;
			else 
			   tx_start <= '1';
			   state_next <= s3;
			end if;
		 when s3 =>
		    if (tx_done='1') then  
			   incb_ram <= '1';
			   state_next <= s2;
			end if;
      end case;
   end process;

end arch;