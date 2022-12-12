library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bitonic is
    generic(
        width : integer := 8;
        byte_capacity : integer := 8
    );
  Port (
     d_out :       out std_logic_vector(width -1 downto 0);
     d_in:         in std_logic_vector(width - 1 downto 0);
     shift_in:     in std_logic;
     shift_out:    in std_logic;
     clear:        in std_logic;
     latch_sorted: in std_logic
  );
end bitonic;

architecture arch of bitonic is
    function log2ceil(m:natural) return natural is
    begin -- note: for log(0) we return 0
        for n in 0 to integer'high loop
            if 2**n >= m then
                return n;
            end if;
        end loop;
    end function log2ceil;
    
    function get_index1(block_group, block_number, comparator_block, comparator_offset: natural) return natural is
    variable tmp: natural;
    variable output: natural;
    begin
        tmp := ((((block_group)**2 + block_group + 2) / 2) - 1) * byte_capacity + block_number * byte_capacity;
        output := 2**(block_group - block_number) * 2 * comparator_block + comparator_offset + tmp + byte_capacity;
        
        return output;
    end function get_index1;
    
    function get_index2(block_group, block_number, comparator_block, comparator_offset: natural) return natural is
    variable tmp: natural;
    variable output: natural;
    begin
        return get_index1(block_group, block_number, comparator_block, comparator_offset) + 2**(block_group - block_number);
    end function get_index2;
    
    
    type data_array is array(byte_capacity - 1 downto 0) of std_logic_vector(width - 1 downto 0);
    type comparator_data is array(byte_capacity + (byte_capacity* log2ceil(byte_capacity) * (log2ceil(byte_capacity) + 1)) / 2 - 1 downto 0) 
            of std_logic_vector(width - 1 downto 0);
            
    signal output_data : data_array;
    signal mux_input1 : data_array;
    signal mux_input2 : data_array;
    signal mux_output : data_array;
    signal load_data : std_logic := '0';
    
    signal comparator_stages : comparator_data;
begin
    data_block: entity work.data_latch(arch)
    generic map(width => width)
    port map(d_in => d_in, 
             clk => shift_in,
             clr => clear,
             d_out => comparator_stages(0));
             
    PARALLEL_INPUT_GEN : for i in 1 to byte_capacity - 1 generate
        data_block: entity work.data_latch(arch)
            generic map(width => width)
            port map(d_in => comparator_stages(i - 1), 
                 clk => shift_in,
                 clr => clear,
                 d_out => comparator_stages(i));
    end generate;
    
    TOTAL_BLOCK_GEN : for current_block_group in 0 to log2ceil(byte_capacity) - 1 generate
        SINGLE_BLOCK_GEN : for current_block in 0 to current_block_group generate
            COMPARATOR_GROUP_GEN : for current_comparator in 0 to (byte_capacity / (2 * 2**(current_block_group - current_block))) - 1 generate
                COMPARATOR_GEN : for comparator_offset in 0 to 2**(current_block_group - current_block) - 1 generate
                    SORT_DOWN_GEN : if (current_comparator / (2**current_block)) mod 2 = 1 generate
                        comparator_block : entity work.comparator(arch)
                            generic map(width => width)
                            port map(val_a => comparator_stages(get_index1(current_block_group, current_block, current_comparator, comparator_offset) - byte_capacity),
                                     val_b => comparator_stages(get_index2(current_block_group, current_block, current_comparator, comparator_offset) - byte_capacity),
                                     high_val => comparator_stages(get_index1(current_block_group, current_block, current_comparator, comparator_offset)),
                                     low_val => comparator_stages(get_index2(current_block_group, current_block, current_comparator, comparator_offset)));
                    end generate;
                    SORT_UP_GEN : if (current_comparator / (2**current_block)) mod 2 = 0 generate
                        comparator_block: entity work.comparator(arch)
                            generic map(width => width)
                            port map(val_a => comparator_stages(get_index1(current_block_group, current_block, current_comparator, comparator_offset) - byte_capacity),
                                     val_b => comparator_stages(get_index2(current_block_group, current_block, current_comparator, comparator_offset) - byte_capacity),
                                     high_val => comparator_stages(get_index2(current_block_group, current_block, current_comparator, comparator_offset)),
                                     low_val => comparator_stages(get_index1(current_block_group, current_block, current_comparator, comparator_offset)));
                    end generate;
                 end generate;
            end generate;
        end generate;
    end generate;
    
    PARALLEL_OUTPUT_GEN : for i in 0 to byte_capacity - 1 generate
        output_data_block: entity work.data_latch(arch)
            generic map(width => width)
            port map(d_in => mux_output(i),
                d_out => output_data(i),
                clk => shift_out,
                clr => '0');
    end generate;
    
    
    MUX_GEN: for i in 0 to byte_capacity - 1 generate
        mux_input2(i) <= comparator_stages(i + (byte_capacity * log2ceil(byte_capacity) * (log2ceil(byte_capacity) + 1)) / 2);
        
        FIRST_MUX_GEN: if i = 0 generate
            mux_input1(i) <= output_data(byte_capacity - 1);
        end generate;
        MUX_GEN: if i /= 0 generate
            mux_input1(i) <= output_data(i - 1);
        end generate;
        
        mux_block: entity work.mux(arch)
            generic map(width => width)
            port map(
                value1 => mux_input1(i),
                value2 => mux_input2(i),
                result => mux_output(i),
                selector => latch_sorted);
    end generate;
    
    d_out <= output_data(byte_capacity - 1);

end arch;
