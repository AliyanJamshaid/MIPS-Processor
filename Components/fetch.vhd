library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;


ENTITY fetch IS
    PORT(
        pc_out, instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        branch_decision, jump_decision, rst, clk : IN STD_LOGIC;
        branch_address, jump_address: IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY fetch;

ARCHITECTURE bhv OF fetch IS
    TYPE mem_array IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    PROCESS(clk,rst)
		  VARIABLE instruction_memory : mem_array := (
			X"202100c8",
			X"20420001",
			X"10220001",
			X"08000001",
			X"00000000",
			X"00a13022",
			X"08000000",
			X"00a13000",
			X"1022fffb",
			X"00612064",
			X"08000000",
			X"aaaaaaaa",
			X"bbbbbbbb",
			X"cccccccc",
			X"dddddddd",
			X"eeeeeeee"
    );
--	 VARIABLE instruction_memory : mem_array := (
--			X"20630002",
--			X"20420002",
--			X"00432020",
--			X"aca40000",
--			X"8ca50000",
--			X"00a13022",
--			X"08000000",
--			X"00a13000",
--			X"1022fffb",
--			X"00612064",
--			X"08000000",
--			X"aaaaaaaa",
--			X"bbbbbbbb",
--			X"cccccccc",
--			X"dddddddd",
--			X"eeeeeeee"
--    );
        VARIABLE pc: STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE index: INTEGER := 0;
    BEGIN 
        if rst = '1' then
            pc := X"00000000";
				instruction<= X"00000000";
        elsif RISING_EDGE(clk)  then
            if branch_decision = '1' then
                pc := branch_address;
            elsif jump_decision = '1' then
                pc := jump_address;
				
            end if;
       
					index := conv_integer(pc(3 DOWNTO 0));
				  instruction <= instruction_memory(index);
				 pc := pc + X"1";
            pc_out <= pc;
        end if;
    END PROCESS;
END bhv;