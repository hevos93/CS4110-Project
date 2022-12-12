-- (adapted from) Listing 5.1
library ieee;
use ieee.std_logic_1164.all;
entity ctr_path is
   port(
      -- Board Controls
      clk, reset: in std_logic;

	  ascii_r, ascii_t: in std_logic_vector(7 downto 0);
      -- This is to be removed
      
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
   type state_type is (s0, s1, s2, s3); --, s4, s5, s6);
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
       input_ram_counter_clr <= '0';
       input_ram_counter_inc <= '0';
       input_ram_wr <= '0';
       input_mux_switch <= '1'; -- Directs data from the input RAM to the shift register
       shift_rom_counter_clr <= '0';
       shift_rom_counter_inc <= '0';
       ram0_wr <= '0';
       ram1_wr <= '0';
       ram2_wr <= '0';
       ram3_wr <= '0';
       ram4_wr <= '0';
       ram5_wr <= '0';
       ram6_wr <= '0';
       ram7_wr <= '0';
       ram0_counter_clr <= '0';
       ram1_counter_clr <= '0';
       ram2_counter_clr <= '0';
       ram3_counter_clr <= '0';
       ram4_counter_clr <= '0';
       ram5_counter_clr <= '0';
       ram6_counter_clr <= '0';
       ram7_counter_clr <= '0';
       ram0_counter_inc <= '0';
       ram1_counter_inc <= '0';
       ram2_counter_inc <= '0';
       ram3_counter_inc <= '0';
       ram4_counter_inc <= '0';
       ram5_counter_inc <= '0';
       ram6_counter_inc <= '0';
       ram7_counter_inc <= '0';
       ram_block_rom_counter_clr <= '0';
       ram_block_rom_counter_inc <= '0';
       temp_ram_counter_clr <= '0';
       temp_ram_counter_inc <= '0';
       temp_ram_wr <= '0';
       output_ram_counter_clr <= '0';
       output_ram_counter_inc <= '0';
       output_ram_wr <= '0';
       tx_start <= '0';
       state_next <= state_reg;
   
      case state_reg is
         when s0 =>
            input_ram_counter_clr <= '1';
            shift_rom_counter_clr <= '1'; 
            ram0_counter_clr <= '1';
            ram1_counter_clr <= '1';
            ram2_counter_clr <= '1';
            ram3_counter_clr <= '1';
            ram4_counter_clr <= '1';
            ram5_counter_clr <= '1';
            ram6_counter_clr <= '1';
            ram7_counter_clr <= '1'; 
            ram_block_rom_counter_clr <= '1'; 
            temp_ram_counter_clr <= '1';            
            output_ram_counter_clr <= '1';
            state_next <= s1;
         when s1 =>
            if (rx_done='1') then
				state_next <= s2;
			else
                state_next <= s1
			end if;
			
         when s2 =>
            if (ascii_t=x"0D") then 
			   state_next <= s0;
			else 
			   input_ram_wr <= '0';
			   ram0_wr <= '1';
               ram1_wr <= '1';
               ram2_wr <= '1';
               ram3_wr <= '1';
               ram4_wr <= '1';
               ram5_wr <= '1';
               ram6_wr <= '1';
               ram7_wr <= '1';
			   
			   temp_ram_wr=1
			   
			   if (sorting done)
					state_next <= s3
			   else
					input_ram_counter_inc<=1
					temp_ram_counter_inc<=1
					
					if (done with bucket?)
						ram_block_rom_counter_inc=1
					
					else
						state_next <= s2
					
					end if;
			   end if;
               			
		 when s3 =>
           ram0_wr <= '0';
           ram1_wr <= '0';
           ram2_wr <= '0';
           ram3_wr <= '0';
           ram4_wr <= '0';
           ram5_wr <= '0';
           ram6_wr <= '0';
           ram7_wr <= '0';
           
           ram0_counter_clr <= '1';
           ram1_counter_clr <= '1';
           ram2_counter_clr <= '1';
           ram3_counter_clr <= '1';
           ram4_counter_clr <= '1';
           ram5_counter_clr <= '1';
           ram6_counter_clr <= '1';
           ram7_counter_clr <= '1';
           
           temp_ram_counter_clr=1
		   
		   output_ram_wr=1
		   
		   if(transfer done)
				state_next <= s4
			else
				temp_ram_counter_inc=1
				output_ram_counter_inc=1
			end if;
			
			when s4 =>
				output_ram_counter_clr=1
				output_ram_wr=0
				tx_start=1
				
				if(transfer done?)
					state_next <= s0
				else
					output_ram_counter_inc=1
					
				end if;         
      end case;
   end process;

end arch;