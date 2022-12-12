----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2022 02:45:29 AM
-- Design Name: 
-- Module Name: demux - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity demux is
    Generic ( width : integer := 8);
    Port ( output1 : out STD_LOGIC_VECTOR (width - 1 downto 0);
           output2 : out STD_LOGIC_VECTOR (width - 1 downto 0);
           input : in STD_LOGIC_VECTOR (width - 1 downto 0);
           selector : in STD_LOGIC);
end demux;

architecture arch of demux is
begin
    process(input, selector)
    begin
        output1 <= (others => '0');
        output2 <= (others => '0');
        case selector is
            when '0' => output1 <= input;
            when '1' => output2 <= input;
            when others => output1 <= input;
        end case;
    end process;
end arch;
