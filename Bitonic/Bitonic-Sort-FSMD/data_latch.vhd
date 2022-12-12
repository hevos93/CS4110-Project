----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2022 04:00:37 PM
-- Design Name: 
-- Module Name: data_latch - Behavioral
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

entity data_latch is
    generic(
        default_value : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
        width : integer := 8
    );
    Port ( d_in : in STD_LOGIC_VECTOR (width - 1 downto 0);
           d_out : out STD_LOGIC_VECTOR (width - 1 downto 0);
           clk : in STD_LOGIC;
           clr : in STD_LOGIC);
end data_latch;

architecture arch of data_latch is
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if clr = '1' then
                d_out <= default_value;
            else
                d_out <= d_in;
            end if;
        end if;
    end process;
    
end arch;
