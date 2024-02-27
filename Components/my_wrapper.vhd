library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
use WORK.my_component.ALL;

ENTITY my_wrapper IS
    PORT (
        rst, clk : IN STD_LOGIC;
--		  fetch_instruction: OUT STD_LOGIC_VECTOR(31 downto 0);
--		  registerA, registerB, destination_reg: OUT STD_LOGIC_VECTOR (31 downto 0);
--		  ImmediateVal : OUT STD_LOGIC_VECTOR(31 downto 0);
--		  jump_address,RESULT_ALU, branch_address : OUT STD_LOGIC_VECTOR(31 downto 0)
        opt : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		  output: out STD_LOGIC_VECTOR(31 downto 0);
        --leds : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);		  
		  
        seg_output0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        seg_output1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        seg_output2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        seg_output3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        seg_output4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        seg_output5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY my_wrapper;

ARCHITECTURE struct OF my_wrapper IS
	 SIGNAL hexdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL jump_addr: STD_LOGIC_VECTOR(31 DOWNTO 0);
	 SIGNAL  pc_out,reg_rs, reg_rt, reg_rd,immediate : STD_LOGIC_VECTOR(31 DOWNTO 0);
	 SIGNAL RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump: STD_LOGIC;
	 SIGNAL AluOp: STD_LOGIC_VECTOR(1 downto 0);
	 SIGNAL ALU_result        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL branch_addr       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL branch_decision   :  STD_LOGIC;
	 SIGNAL readData: STD_LOGIC_VECTOR(31 downto 0);
BEGIN
    fetch_U: fetch
        PORT MAP (
            pc_out, instruction, branch_decision, Jump,
            rst, clk, branch_addr,jump_addr
        );

    decode_U: decode
        PORT MAP (
            instruction,readData ,ALU_result, RegDst,
            RegWrite, MemtoReg, rst, clk, reg_rs, reg_rt,
				reg_rd, jump_addr, immediate
        );
		  
	control_U :control
    PORT MAP ( 
			  instruction,
           RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump,
			  AluOp,
			  rst
			  );
	
	execute_U :execute
    PORT MAP (
        pc_out,
        reg_rt,
        reg_rs,
        immediate,
        AluOP,
        Alusrc,
        Branch,
        ALU_result,
        branch_addr,
        branch_decision
    );
	 
	 datamemory_U : datamemory
    Port MAP ( 
        ALU_result,
        reg_rt,
        readData,
        MemWrite, MemRead
    );
	
		  
--		  fetch_instruction<= instruction;
--		  registerA<= reg_rs;
--		  registerB<= reg_rt;
--		  destination_reg<= reg_rd;
--		  ImmediateVal<=immediate;
--		  jump_address<=jump_addr;
--		  branch_address<=branch_addr;
--		  RESULT_ALU<=ALU_result;
		  
process(opt)
    begin
        CASE opt IS
            WHEN "000" =>
                hexdata <= instruction;
            WHEN "001" =>
                hexdata <= reg_rs;
            WHEN "010" =>
                hexdata <= reg_rt;
            WHEN "011" =>
                hexdata <= reg_rd;
				   WHEN "100" =>
					 hexdata <= immediate;
            WHEN "101" =>
                hexdata <= jump_addr;
				WHEN "110" =>
                hexdata <= branch_addr;
				WHEN others =>
                hexdata <= ALU_result;
        END CASE;
    end process;
	 output<=hexdata;
	 
	   U0: SevenSegment PORT MAP (hexdata(3 DOWNTO 0), seg_output0);
    U1: SevenSegment PORT MAP (hexdata(7 DOWNTO 4), seg_output1);
    U2: SevenSegment PORT MAP (hexdata(11 DOWNTO 8), seg_output2);
    U3: SevenSegment PORT MAP (hexdata(15 DOWNTO 12), seg_output3);
    U4: SevenSegment PORT MAP (hexdata(19 DOWNTO 16), seg_output4);
    U5: SevenSegment PORT MAP (hexdata(23 DOWNTO 20), seg_output5);

    

END struct;
