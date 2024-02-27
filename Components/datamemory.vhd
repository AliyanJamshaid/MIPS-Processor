library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datamemory is
    Port ( 
        address : in STD_LOGIC_VECTOR(31 downto 0);
        writeData : in STD_LOGIC_VECTOR(31 downto 0);
        readData : out STD_LOGIC_VECTOR(31 downto 0);
        memWrite, memRead : in STD_LOGIC
    );
end datamemory;

architecture Behavioral of datamemory is
    type mem_array is array(0 to 31) of std_logic_vector(31 downto 0);
    shared variable memory : mem_array;
begin
    -- Process for memory write
    mem_write: process(address, memWrite)
    begin
            if memWrite = '1' then
                memory(conv_integer(address(2 downto 0))) := writeData;
            end if;
    end process;

    -- Process for memory read
    mem_read: process(address,memRead)
    begin
            if memRead = '1' then
                readData <= memory(conv_integer(address(2 downto 0)));
            end if;
    end process;
end Behavioral;
