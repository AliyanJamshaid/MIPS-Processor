LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY execute IS
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
END execute;

ARCHITECTURE behv OF execute IS
BEGIN
    PROCESS(PC4)
        VARIABLE operand_2       : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE zero            : STD_LOGIC; 
        VARIABLE funct           : STD_LOGIC_VECTOR(5 DOWNTO 0);
        VARIABLE branch_offset   : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE temp_branch_addr: STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        IF (ALUsrc = '0') THEN
            operand_2 := register_rt;
        ELSE
            operand_2 := immediate;
        END IF;

        CASE ALUOP IS
            WHEN "00" =>
                ALU_result <= (register_rs + operand_2);
            WHEN "01" =>
                ALU_result <= (register_rs - operand_2);
            WHEN "10" =>
                funct := immediate(5 DOWNTO 0);
                CASE funct IS
                    WHEN "100000" =>
                        ALU_result <= register_rs + operand_2;
                    WHEN "100010" =>
                        ALU_result <= register_rs - operand_2;
                    WHEN "111011" =>
                         ALU_result <= (register_rs NAND operand_2);
                    WHEN OTHERS =>
                        ALU_result <= X"00000000";
                END CASE;
					WHEN OTHERS =>
						ALU_result <= X"00000000";
        END CASE;

        branch_offset := immediate;
        temp_branch_addr := std_logic_vector(unsigned(branch_offset) + unsigned(PC4));
        branch_decision <= beq_control AND zero;
        branch_addr <= temp_branch_addr;

    END PROCESS;
END behv;
