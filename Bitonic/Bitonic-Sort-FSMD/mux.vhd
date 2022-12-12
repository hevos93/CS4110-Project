library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    Generic ( width : integer := 8);
    Port ( value1 : in STD_LOGIC_VECTOR (width - 1 downto 0);
           value2 : in STD_LOGIC_VECTOR (width - 1 downto 0);
           result : out STD_LOGIC_VECTOR (width - 1 downto 0);
           selector : in STD_LOGIC);
end mux;

architecture arch of mux is
begin
    process(value1, value2, selector)
    begin
        if selector = '0' then
            result <= value1;
        else
            result <= value2;
        end if;
    end process;
end arch;