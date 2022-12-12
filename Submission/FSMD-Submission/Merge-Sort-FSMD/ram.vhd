----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/11/2022 02:17:21 PM
-- Design Name: 
-- Module Name: ram - Behavioral
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

entity ram is
    generic (
        ADDR_WIDTH: integer:=8;
        DATA_WIDTH: integer:=8
    );
    Port ( data_in : in STD_LOGIC_VECTOR(7 downto 0);
           addr_left, addr_right : in STD_LOGIC_VECTOR(7 downto 0);
           data_out_left, data_out_right : out STD_LOGIC_VECTOR(7 downto 0);
           wr : in STD_LOGIC);
end ram;

architecture arch of ram is
    type ram_type is array (2**ADDR_WIDTH-1 downto 0) 
        of std_logic_vector (DATA_WIDTH-1 downto 0);
    signal ram: ram_type;
    signal tmp: std_logic_vector (DATA_WIDTH-1 downto 0);

begin

    process(wr)
    begin
        if (rising_edge(wr)) then
            ram(to_integer(unsigned(addr_left))) <= data_in;
        end if;
    end process;
    
    data_out_left <= ram(to_integer(unsigned(addr_left)));
    data_out_right <= ram(to_integer(unsigned(addr_right)));
    
end arch;
