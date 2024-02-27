library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


PACKAGE my_component IS
COMPONENT fetch IS
   PORT(
        pc_out, instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        branch_decision, jump_decision, rst, clk : IN STD_LOGIC;
        branch_address, jump_address: IN STD_LOGIC_VECTOR(31 DOWNTO 0)
		  );
END COMPONENT;

COMPONENT SevenSegment IS
   Port ( 
			  hex_input : in  STD_LOGIC_VECTOR(3 downto 0);
           seg_output : out  STD_LOGIC_VECTOR(6 downto 0)
			 );
END COMPONENT;

COMPONENT decode IS
   Port ( 
			   instruction, mem_data, alu_result: in std_logic_vector(31 downto 0);
				regdst, regwrite, memtoreg, reset, clk: in std_logic;
				reg_rs, reg_rt,reg_rd, jump_add, immediate: out std_logic_vector(31 downto 0)
			 );
END COMPONENT;
COMPONENT execute IS
    PORT (
        PC4               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        register_rt       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        register_rs       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        immediate         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALUOP             : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUsrc            : IN STD_LOGIC;
        beq_control       : IN STD_LOGIC;
        ALU_result        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        branch_addr       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        branch_decision   : OUT STD_LOGIC
    );
END COMPONENT;
COMPONENT control is
    Port ( 
			  instruction : IN  STD_LOGIC_VECTOR(31 downto 0);
           RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump: OUT STD_LOGIC;
			  AluOp: OUT STD_LOGIC_VECTOR(1 downto 0);
			  reset: IN STD_LOGIC
			  );
end COMPONENT;
COMPONENT datamemory is
    Port ( 
        address : in STD_LOGIC_VECTOR(31 downto 0);
        writeData : in STD_LOGIC_VECTOR(31 downto 0);
        readData : out STD_LOGIC_VECTOR(31 downto 0);
        memWrite, memRead : in STD_LOGIC
    );
end COMPONENT;

END my_component;