library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity bitonic_tb is
--  Port ( );
end bitonic_tb;

architecture Behavioral of bitonic_tb is
    constant clk_period : time := 10 ns;

    constant byte_capacity : natural := 8;
    type data_array is array(0 to 7) of std_logic_vector(7 downto 0);
    constant data : data_array := (
    x"15", -- value 1
    x"d9", -- value 2
    x"02", -- value 3
    x"a2", -- value 4
    x"34", -- value 5
    x"81", -- value 6
    x"92", -- value 7
    x"17"); -- value 8
    component bitonic
    generic (
        width : integer := 8;
        byte_capacity : integer := 8
    );
    port(      
            d_out :        out std_logic_vector(7 downto 0) := (others => '0');
            d_in :         in std_logic_vector(7 downto 0)  := (others => '0');
            shift_in :     in std_logic                     := '0';
            shift_out :    in std_logic                     := '0';
            latch_sorted : in std_logic                     := '0';
            clear :        in std_logic                     := '0');
    end component;
    
    signal shift_in, shift_out, latch_sorted, clear: std_logic;
    signal d_in : std_logic_vector(7 downto 0);
    signal d_out : std_logic_vector(7 downto 0);
begin
    uut: bitonic
    generic map(byte_capacity => 8)
    port map(
        d_in => d_in,
        d_out => d_out,
        clear => clear,
        shift_in => shift_in,
        shift_out => shift_out,
        latch_sorted => latch_sorted);

    stim: process
    begin
        latch_sorted <= '0';
        shift_out <= '0';
        shift_in <= '0';
        clear <= '0';
        wait for clk_period;
    
        clear <= '1';
        shift_in <= '1';
        wait for clk_period;
        shift_in <= '0';
        clear <= '0';
        wait for clk_period;
        
        for i in 0 to byte_capacity - 1 loop
            d_in <= data(i);
            shift_in <= '1';
            wait for clk_period;
            shift_in <='0';
            wait for clk_period;
        end loop;
        
        latch_sorted <= '1';
        wait for clk_period;
        shift_out <= '1';
        wait for clk_period;
        latch_sorted <= '0';
        shift_out <= '0';
        wait for clk_period;
        
        for i in 0 to byte_capacity - 1 loop
            shift_out <= '1';
            wait for clk_period;
            shift_out <='0';
            wait for clk_period;
        end loop;
        wait for 1ms;
    end process;
end Behavioral;
