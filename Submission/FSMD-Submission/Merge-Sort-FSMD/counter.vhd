----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/11/2022 02:17:21 PM
-- Design Name: 
-- Module Name: counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( inc : in STD_LOGIC;
           clr : in STD_LOGIC;
           set : in STD_LOGIC;
           cnt_in : in STD_LOGIC_VECTOR(7 downto 0);
           cnt_out : out STD_LOGIC_VECTOR(7 downto 0)
           );
end counter;

architecture Behavioral of counter is
    signal count_val : unsigned (7 downto 0);
begin
    
    process(inc)
    begin
        if (rising_edge(inc)) then
            count_val <= count_val + 1;
        end if ;
    end process;

    process(set)
    begin
        if (rising_edge(set)) then
            count_val <= unsigned(cnt_in);
        end if;
    end process;
    
    process(clr)
    begin
        if (rising_edge(clr)) then
            count_val <= (others => '0');
        end if;
    end process;

    cnt_out <= std_logic_vector(count_val);

end Behavioral;
