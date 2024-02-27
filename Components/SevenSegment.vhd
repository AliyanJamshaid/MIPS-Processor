library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SevenSegment is
    Port ( 
			  hex_input : in  STD_LOGIC_VECTOR(3 downto 0);
           seg_output : out  STD_LOGIC_VECTOR(6 downto 0)
			 );
end SevenSegment;

architecture Behv of SevenSegment is
begin
    process(hex_input)
    begin
        case hex_input is
            when "0000" =>
                seg_output <= "1000000"; --0
            when "0001" =>
                seg_output <= "1111001"; --1
            when "0010" =>
                seg_output <= "0100100"; --2
            when "0011" =>
                seg_output <= "0110000"; --3
            when "0100" =>
                seg_output <= "0011001"; --4
            when "0101" =>
                seg_output <= "0010010"; --5
            when "0110" =>
                seg_output <= "0000010"; --6
            when "0111" =>
                seg_output <= "1111000"; --7
            when "1000" =>
                seg_output <= "0000000"; --8
            when "1001" =>
                seg_output <= "0010000"; --9
            when "1010" =>
                seg_output <= "0001000"; --a
            when "1011" =>
                seg_output <= "0000011"; --b
            when "1100" =>
                seg_output <= "1000110"; --c
            when "1101" =>
                seg_output <= "0100001"; --d
            when "1110" =>
                seg_output <= "0110000"; --e
            when others =>
                seg_output <= "0001110"; --f
        end case;
    end process;
end Behv;
