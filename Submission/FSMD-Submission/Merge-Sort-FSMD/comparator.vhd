----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/11/2022 02:17:21 PM
-- Design Name: 
-- Module Name: comparator - Behavioral
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

entity comparator is
    Port ( left_value : in STD_LOGIC_VECTOR(7 downto 0);
           right_value : in STD_LOGIC_VECTOR(7 downto 0);
           ctrl : in STD_LOGIC_VECTOR(1 downto 0);
           sel : out STD_LOGIC;
           value_out : out STD_LOGIC_VECTOR(7 downto 0));
end comparator;

architecture Behavioral of comparator is

begin

    process(left_value, right_value, ctrl)
    begin
        case ctrl is 
            when "10" => 
                value_out <= left_value;
            when "01" =>
                value_out <= right_value;
            when "00" => 
                if (left_value < right_value) then
                    value_out <= left_value;
                    sel <= '0';
                else
                    value_out <= right_value;
                    sel <= '1';
                end if;
            when others =>
                if (left_value < right_value) then
                    value_out <= left_value;
                    sel <= '0';
                else
                    value_out <= right_value;
                    sel <= '1';
                end if;
        end case;
    end process;

end Behavioral;
