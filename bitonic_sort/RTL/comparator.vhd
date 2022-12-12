library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity comparator is
    generic (
        width : integer := 8
    );
    Port ( val_a : in STD_LOGIC_VECTOR (width - 1 downto 0);
           val_b : in STD_LOGIC_VECTOR (width - 1 downto 0);
           high_val : out STD_LOGIC_VECTOR (width - 1 downto 0);
           low_val : out STD_LOGIC_VECTOR (width - 1 downto 0));
end comparator;

architecture arch of comparator is

begin
    high_val <= val_a when (unsigned(val_a) < unsigned(val_b)) else val_b;
    low_val  <= val_b when (unsigned(val_a) < unsigned(val_b)) else val_a;

end arch;
