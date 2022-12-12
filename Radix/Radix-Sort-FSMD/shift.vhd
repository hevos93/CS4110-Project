library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity shift is
	port(
		din: in std_logic_vector(7 downto 0);
		shift_vector: in std_logic_vector(3 downto 0);
		dout: out std_logic_vector(2 downto 0)
	);
end shift;
 
architecture arch of shift is
       signal shift_integer: integer;
	   signal shifted_signal: std_logic_vector (7 downto 0);
begin
 
  process is
  begin
    -- r_Unsigned_R <= shift_right(unsigned(r_Shift1), 2);
    -- r_Signed_R   <= shift_right(signed(r_Shift1), 2);
     
    shift_integer <= to_integer(signed(shift_vector));
    
    shifted_signal <= std_logic_vector(shift_right(signed(din),shift_integer));
    
    dout <= shifted_signal(2 downto 0);
    
    wait for 100 ns;
  end process;
end architecture arch; 