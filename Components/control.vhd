library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is
    Port ( 
			  instruction : IN  STD_LOGIC_VECTOR(31 downto 0);
           RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump: OUT STD_LOGIC;
			  AluOp: OUT STD_LOGIC_VECTOR(1 downto 0);
			  reset: IN STD_LOGIC
			  );
end control;

architecture Behavioral of control is
begin
    process(instruction, reset)
	 variable opcode : STD_LOGIC_VECTOR(5 downto 0);
    begin
		if(reset='1') then 
				 RegDst    <= '0';
                ALUSrc    <= '0';
                MemtoReg  <= '0';
                RegWrite  <= '1';
                MemRead   <= '0';
                MemWrite  <= '0';
                Branch    <= '0';
                Jump      <= '0';
		
		else opcode:= instruction(31 downto 26);
		
        case opcode is
			
            when "000000" => --R type
                RegDst    <= '1';
                ALUSrc    <= '0';
                MemtoReg  <= '0';
                RegWrite  <= '1';
                MemRead   <= '0';
                MemWrite  <= '0';
                Branch    <= '0';
                Jump      <= '0';
					 AluOP	  <= "10";

            when "100011" => -- LW
                RegDst    <= '0';
                ALUSrc    <= '1';
                MemtoReg  <= '1';
                RegWrite  <= '1';
                MemRead   <= '1';
                MemWrite  <= '0';
                Branch    <= '0';
                Jump      <= '0';
                AluOp     <= "00";
					 
				 when "101011" => --SW
                RegDst    <= '0';
                ALUSrc    <= '1';
                MemtoReg  <= '0';
                RegWrite  <= '0';
                MemRead   <= '0';
                MemWrite  <= '1';
                Branch    <= '0';
                Jump      <= '0';
                AluOp     <= "00";
					 
					 
            when "000100" => --beq
                RegDst    <=  '0';
                ALUSrc    <= '0';
                MemtoReg  <=  '0';
                RegWrite  <=  '0';
                MemRead   <= '0';
                MemWrite  <= '0';
                Branch    <= '1';
                Jump      <= '0';
                AluOp     <= "01";
            when "000010" => -- JUMP
                RegDst    <= '0';
                ALUSrc    <= '0';
                MemtoReg  <= '0';
                RegWrite  <= '0';
                MemRead   <= '0';
                MemWrite  <= '0';
                Branch    <= '0';
                Jump      <= '1';
                AluOp     <= "00";
					 
				when "001000" => --add immediate
					 RegDst    <= '0';
                ALUSrc    <= '1';
                MemtoReg  <= '0';
                RegWrite  <= '1';
                MemRead   <= '0';
                MemWrite  <= '0';
                Branch    <= '0';
                Jump      <= '0';
                AluOp     <= "00";
					 
            when others => 
                RegDst    <= '0';
                ALUSrc    <= '0';
                MemtoReg  <= '0';
                RegWrite  <= '0';
                MemRead   <= '0';
                MemWrite  <= '0';
                Branch    <= '0';
                Jump      <= '0';
                AluOp     <= "00";
        end case;
		 end if;
    end process;
end Behavioral;
