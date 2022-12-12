-- (adapted from) Listing 7.4
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity radix is
   generic(
     -- Default setting:
     -- 19,200 baud, 8 data bis, 1 stop bits
      DBIT: integer:=8;     -- # data bits
      SB_TICK: integer:=16; -- # ticks for stop bits, 16/24/32: for 1/1.5/2 stop bits
      DVSR: integer:= 326;  -- baud rate divisor: DVSR = 100M/(16*baud rate)
      DVSR_BIT: integer:=9; -- # bits of DVSR
      ROM_ADDR_WIDTH: integer:=5;   -- # maximum size of the ROM (key): 2^5 (32)
	  RAM_ADDR_WIDTH: integer:=10;  -- # maximum size of the RAM: 2^10 (1024)
	  RAM_DATA_WIDTH: integer:=8   -- # 8-bit data words
   );
   port(
      clk, reset: in std_logic;
      rx: in std_logic;
      tx: out std_logic
   );
end radix;

architecture str_arch of radix is
   signal tick: std_logic;
   signal rx_done: std_logic;
   signal input, output: std_logic_vector(7 downto 0);
   signal tx_start, tx_done: std_logic;
   
   signal input_ram_counter_clr, input_ram_counter_inc, input_ram_wr: std_logic;
   signal input_ram_addr: std_logic_vector(9 downto 0);
   signal input_ram_input_mux: std_logic_vector(7 downto 0);
   signal temp_ram_input_mux: std_logic_vector(7 downto 0);
   
   signal input_mux_switch: std_logic;
   
   signal shift_rom_counter_clr, shift_rom_counter_inc: std_logic;
   signal shift_rom_addr: std_logic_vector(3 downto 0);
   signal shift_rom_addr_mux:  std_logic_vector(3 downto 0);
   signal shift_addr_mux:  std_logic_vector(2 downto 0);
   
   signal shift_input: std_logic_vector(7 downto 0);
   signal shift_output: std_logic_vector(2 downto 0);
   
   
   signal ram0_in: std_logic_vector(7 downto 0);
   signal ram0_counter_clr, ram0_counter_inc, ram0_wr: std_logic;
   signal output_ram0_counter: std_logic_vector(3 downto 0);
   signal ram0_out: std_logic_vector(7 downto 0);
   
   signal ram1_in: std_logic_vector(7 downto 0);
   signal ram1_counter_clr, ram1_counter_inc, ram1_wr: std_logic;
   signal output_ram1_counter: std_logic_vector(3 downto 0);
   signal ram1_out: std_logic_vector(7 downto 0);
   
   signal ram2_in: std_logic_vector(7 downto 0);
   signal ram2_counter_clr, ram2_counter_inc, ram2_wr: std_logic;
   signal output_ram2_counter: std_logic_vector(3 downto 0);
   signal ram2_out: std_logic_vector(7 downto 0);
   
   signal ram3_in: std_logic_vector(7 downto 0);
   signal ram3_counter_clr, ram3_counter_inc, ram3_wr: std_logic;
   signal output_ram3_counter: std_logic_vector(3 downto 0);
   signal ram3_out: std_logic_vector(7 downto 0);
    
   signal ram4_in: std_logic_vector(7 downto 0);
   signal ram4_counter_clr, ram4_counter_inc, ram4_wr: std_logic;
   signal output_ram4_counter: std_logic_vector(3 downto 0);
   signal ram4_out: std_logic_vector(7 downto 0);
   
   signal ram5_in: std_logic_vector(7 downto 0);
   signal ram5_counter_clr, ram5_counter_inc, ram5_wr: std_logic;
   signal output_ram5_counter: std_logic_vector(3 downto 0);
   signal ram5_out: std_logic_vector(7 downto 0);
   
   signal ram6_in: std_logic_vector(7 downto 0);
   signal ram6_counter_clr, ram6_counter_inc, ram6_wr: std_logic;
   signal output_ram6_counter: std_logic_vector(3 downto 0);
   signal ram6_out: std_logic_vector(7 downto 0);
   
   signal ram7_in: std_logic_vector(7 downto 0);
   signal ram7_counter_clr, ram7_counter_inc, ram7_wr: std_logic;
   signal output_ram7_counter: std_logic_vector(3 downto 0);
   signal ram7_out: std_logic_vector(7 downto 0);   


   signal ram_block_addr:std_logic_vector(2 downto 0);
   
   signal ram_block_rom_counter_clr, ram_block_rom_counter_inc: std_logic;
   signal ram_block_rom_addr: std_logic_vector(2 downto 0);
   signal ram_block_rom_addr_mux: std_logic_vector(2 downto 0);
   
   signal temp_ram_counter_clr, temp_ram_counter_inc, temp_ram_wr: std_logic;
   signal temp_ram_input: std_logic_vector(7 downto 0);
   signal temp_ram_addr: std_logic_vector(3 downto 0);
   
   signal output_ram_input: std_logic_vector(7 downto 0);
   signal output_ram_counter_clr, output_ram_counter_inc, output_ram_wr: std_logic;
   signal output_ram_addr: std_logic_vector(3 downto 0);

begin
    -- FSM
    ctr_path: entity work.ctr_path(arch)
        port map(
            -- Board Controls
            clk=>clk, reset => reset,
            
            -- Reciever
            rx_done=>rx_done, ascii_r=>input,
            
            -- Input RAM counter
            input_ram_counter_clr=>input_ram_counter_clr,
            input_ram_counter_inc=>input_ram_counter_inc,
            
            -- Input RAM
            input_ram_wr=>input_ram_wr,
            
            -- Input MUX
            input_mux_switch=>input_mux_switch,
            
            -- Shift ROM
            shift_rom_counter_clr=>shift_rom_counter_clr,
            shift_rom_counter_inc=>shift_rom_counter_inc,
            
            -- RAM BLOCK
            ram0_wr=>ram0_wr, ram1_wr=>ram1_wr, ram2_wr=>ram2_wr, ram3_wr=>ram3_wr, 
            ram4_wr=>ram4_wr, ram5_wr=>ram5_wr, ram6_wr=>ram6_wr, ram7_wr=>ram7_wr,
            
            ram0_counter_clr=>ram0_counter_clr, ram1_counter_clr=>ram1_counter_clr,
            ram2_counter_clr=>ram2_counter_clr, ram3_counter_clr=>ram3_counter_clr,
            ram4_counter_clr=>ram4_counter_clr, ram5_counter_clr=>ram5_counter_clr,
            ram6_counter_clr=>ram6_counter_clr, ram7_counter_clr=>ram7_counter_clr,
      
            ram0_counter_inc=>ram0_counter_inc, ram1_counter_inc=>ram1_counter_inc,
            ram2_counter_inc=>ram2_counter_inc, ram3_counter_inc=>ram3_counter_inc,
            ram4_counter_inc=>ram4_counter_inc, ram5_counter_inc=>ram5_counter_inc,
            ram6_counter_inc=>ram6_counter_inc, ram7_counter_inc=>ram7_counter_inc,
            
            -- ROM after RAM BLOCK before temp RAM
            ram_block_rom_counter_clr=>ram_block_rom_counter_clr,
            ram_block_rom_counter_inc=>ram_block_rom_counter_inc,
            
            -- Temp RAM counter
            temp_ram_counter_clr=>temp_ram_counter_clr, 
            temp_ram_counter_inc=>temp_ram_counter_inc,
                       
            -- Temp RAM
            temp_ram_wr=>temp_ram_wr,
           
           -- Output RAM counter
           output_ram_counter_clr=>output_ram_counter_clr, output_ram_counter_inc=>output_ram_counter_inc,
           
           -- Output RAM
           output_ram_wr=>output_ram_wr,
            
            -- Transmitter
            tx_start=>tx_start,
            tx_done=>tx_done,
            ascii_t=>output
        );
    -- Reciever 
    uart_rx_unit: entity work.uart_rx(arch)
       generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
       port map(
	       clk=>clk, reset=>reset, rx=>rx,
           s_tick=>tick, rx_done_tick=>rx_done,
           dout=>input
        );
    -- Transmitter
    uart_tx_unit: entity work.uart_tx(arch)
       generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
       port map(
	       clk=>clk, reset=>reset,
           tx_start=>tx_start,
           s_tick=>tick, din=>output,
           tx_done_tick=> tx_done, tx=>tx
        );
    -- Counter for the input ram 
    input_ram_counter: entity work.input_ram_counter(arch)
        port map (
            clk=>clk, reset=>reset,
            syn_clr=>input_ram_counter_clr,
            load=>'0', en=>input_ram_counter_inc,
            up=>'1', d=>(others=>'0'),
            max_tick=>open, min_tick=>open,
            q=>input_ram_addr
        );
    -- Input ram
    input_ram: entity work.input_ram(arch)
        port map (
        clk=>clk, wr=>input_ram_wr,
        din=>input, addr=>input_ram_addr,
        dout=>input_ram_input_mux
        );
        
    -- Mux before shift
    input_mux_shift: entity work.input_mux_shift(arch)
        port map(
            clk=>clk, reset=>reset, sel=>input_mux_switch,
            in0=>input_ram_input_mux,
            in1=>temp_ram_input_mux,
            sseg=>shift_input
        );  
        
    -- Counter for the bit-shift ROM
    shift_rom_counter: entity work.shift_rom_counter(arch)
        port map(
            clk=>clk, reset=>reset,
            syn_clr=>shift_rom_counter_clr,
            load=>'0', en=>shift_rom_counter_inc,
            up=>'1', d=>(others=>'0'),
            max_tick=>open, min_tick=>open,
            q=>shift_rom_addr
        );
    
    -- ROM for bit-shift
    shift_rom: entity work.shift_rom(arch)
        port map(
            addr=>shift_rom_addr,
            data=>shift_rom_addr_mux
        );
        
    shift: entity work.shift(arch)
        port map(
        din=>shift_input,
        shift_vector=>shift_rom_addr_mux,
        dout=>shift_addr_mux
        );
        
    -- Mux after shift
    shift_mux_ram_block: entity work.shift_mux_ram_block(arch)
        port map(
            clk=>clk, reset=>reset,
            sel=>shift_addr_mux,
            in0=>input_ram_input_mux,
            out0=>ram0_in,
            out1=>ram1_in,
            out2=>ram2_in,
            out3=>ram3_in,
            out4=>ram4_in,
            out5=>ram5_in,
            out6=>ram6_in,
            out7=>ram7_in
        );  
        
    -- Counter for ROM after RAM Block
    ram_block_rom_counter: entity work.ram_block_rom_counter(arch)
    port map(
        clk=>clk, reset=>reset,
            syn_clr=>ram_block_rom_counter_clr,
            load=>'0', en=>ram_block_rom_counter_inc,
            up=>'1', d=>(others=>'0'),
            max_tick=>open, min_tick=>open,
            q=>ram_block_rom_addr
    );
    
    -- ROM for MUX after RAM Block
    ram_block_rom: entity work.ram_block_rom(arch)
    port map(
        addr=>ram_block_rom_addr,
        data=>ram_block_rom_addr_mux
    );
    
    -- Mux after RAM blocks
    ram_block_mux_temp_ram: entity work.ram_block_mux_temp_ram(arch)
        port map(
            clk=>clk, reset=>reset,
            sel=>ram_block_rom_addr_mux,
            in0=>ram0_out,
            in1=>ram1_out,
            in2=>ram2_out,
            in3=>ram3_out,
            in4=>ram4_out,
            in5=>ram5_out,
            in6=>ram6_out,
            in7=>ram7_out,
            out0=>temp_ram_input
        );

    -- Temporary ram counter after RAM Block MUX 
    temp_ram_counter: entity work.temp_ram_counter(arch)
        port map (
            clk=>clk, reset=>reset,
            syn_clr=>temp_ram_counter_clr,
            load=>'0', en=>temp_ram_counter_inc,
            up=>'1', d=>(others=>'0'),
            max_tick=>open, min_tick=>open,
            q=>temp_ram_addr
        );
        
    -- Temporary ram after RAM Block MUX
    temp_ram: entity work.temp_ram(arch)
        port map (
            clk=>clk, wr=>temp_ram_wr,
            din=>temp_ram_input, addr=>temp_ram_addr,
            dout0=>input_ram_input_mux,
            dout1=>output_ram_input
        );
        
    -- Counter for Output RAM
    output_ram_counter: entity work.output_ram_counter(arch)
        port map (
            clk=>clk, reset=>reset,
            syn_clr=>output_ram_counter_clr,
            load=>'0', en=>output_ram_counter_inc,
            up=>'1', d=>(others=>'0'),
            max_tick=>open, min_tick=>open,
            q=>output_ram_addr
        );
    
    -- Output RAM
    output_ram: entity work.output_ram(arch)
        port map(
            clk=>clk, wr=>output_ram_wr,
            addr=>output_ram_addr,
            din=>output_ram_input,
            dout=>output
        );
    
    
    
    -- RAM BLOCK --
        -- Ram0
           -- Counter
           ram0_counter: entity work.ram_block_counter(arch)
            port map(
                clk=>clk, reset=>reset,
                syn_clr=>ram0_counter_clr,
                en=>ram0_counter_inc,
                load=>'0', up=>'1', d=>(others=>'0'),
                max_tick=>open, min_tick=>open,
                q=>output_ram0_counter
            );
               
           -- Ram module
           ram0: entity work.ram_block(arch)
           port map(
                clk=>clk, wr=>ram0_wr,
                addr=>output_ram0_counter,
                din=>ram0_in, dout=>ram0_out
           );
 
        -- Ram1
           -- Counter
           ram1_counter: entity work.ram_block_counter(arch)
            port map(
                clk=>clk, reset=>reset,
                syn_clr=>ram1_counter_clr,
                en=>ram1_counter_inc,
                load=>'0', up=>'1', d=>(others=>'0'),
                max_tick=>open, min_tick=>open,
                q=>output_ram1_counter
            );
               
           -- Ram module
           ram1: entity work.ram_block(arch)
           port map(
                clk=>clk, wr=>ram1_wr,
                addr=>output_ram1_counter,
                din=>ram1_in, dout=>ram1_out
           );        
               
        -- Ram2
            -- Counter
            ram2_counter: entity work.ram_block_counter(arch)
            port map(
                clk=>clk, reset=>reset,
                syn_clr=>ram2_counter_clr,
                en=>ram2_counter_inc,
                load=>'0', up=>'1', d=>(others=>'0'),
                max_tick=>open, min_tick=>open,
                q=>output_ram2_counter
            );
               
           -- Ram module
           ram2: entity work.ram_block(arch)
           port map(
                clk=>clk, wr=>ram2_wr,
                addr=>output_ram2_counter,
                din=>ram2_in, dout=>ram2_out
           );
  
        
        -- Ram3
            -- Counter
            ram3_counter: entity work.ram_block_counter(arch)
            port map(
                clk=>clk, reset=>reset,
                syn_clr=>ram3_counter_clr,
                en=>ram3_counter_inc,
                load=>'0', up=>'1', d=>(others=>'0'),
                max_tick=>open, min_tick=>open,
                q=>output_ram3_counter
            );
               
           -- Ram module
           ram3: entity work.ram_block(arch)
           port map(
                clk=>clk, wr=>ram3_wr,
                addr=>output_ram3_counter,
                din=>ram3_in, dout=>ram3_out
           );
        
        -- Ram4
             -- Counter
            ram4_counter: entity work.ram_block_counter(arch)
            port map(
                clk=>clk, reset=>reset,
                syn_clr=>ram4_counter_clr,
                en=>ram4_counter_inc,
                load=>'0', up=>'1', d=>(others=>'0'),
                max_tick=>open, min_tick=>open,
                q=>output_ram4_counter
            );
               
           -- Ram module
           ram4: entity work.ram_block(arch)
           port map(
                clk=>clk, wr=>ram4_wr,
                addr=>output_ram4_counter,
                din=>ram4_in, dout=>ram4_out
           );
        
        -- Ram5
             -- Counter
            ram5_counter: entity work.ram_block_counter(arch)
            port map(
                clk=>clk, reset=>reset,
                syn_clr=>ram5_counter_clr,
                en=>ram5_counter_inc,
                load=>'0', up=>'1', d=>(others=>'0'),
                max_tick=>open, min_tick=>open,
                q=>output_ram5_counter
            );
               
           -- Ram module
           ram5: entity work.ram_block(arch)
           port map(
                clk=>clk, wr=>ram5_wr,
                addr=>output_ram5_counter,
                din=>ram5_in, dout=>ram5_out
           );
        
        -- Ram6
             -- Counter
            ram6_counter: entity work.ram_block_counter(arch)
            port map(
                clk=>clk, reset=>reset,
                syn_clr=>ram6_counter_clr,
                en=>ram6_counter_inc,
                load=>'0', up=>'1', d=>(others=>'0'),
                max_tick=>open, min_tick=>open,
                q=>output_ram6_counter
            );
               
           -- Ram module
           ram6: entity work.ram_block(arch)
           port map(
                clk=>clk, wr=>ram6_wr,
                addr=>output_ram6_counter,
                din=>ram6_in, dout=>ram6_out
           );
        
        -- Ram7
             -- Counter
            ram7_counter: entity work.ram_block_counter(arch)
            port map(
                clk=>clk, reset=>reset,
                syn_clr=>ram7_counter_clr,
                en=>ram7_counter_inc,
                load=>'0', up=>'1', d=>(others=>'0'),
                max_tick=>open, min_tick=>open,
                q=>output_ram7_counter
            );
               
           -- Ram module
           ram7: entity work.ram_block(arch)
           port map(
                clk=>clk, wr=>ram7_wr,
                addr=>output_ram7_counter,
                din=>ram7_in, dout=>ram7_out
           );
        
end str_arch;