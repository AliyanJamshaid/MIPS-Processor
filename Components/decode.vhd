library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity decode is
  port (
    instruction, mem_data, alu_result: in std_logic_vector(31 downto 0);
    regdst, regwrite, memtoreg, reset, clk: in std_logic;
    reg_rs, reg_rt, reg_rd,jump_add, immediate: out std_logic_vector(31 downto 0)
  );
end decode;

------------------------------Architecture-----------------------------------------

architecture behv of decode is

------------------------------Register File-----------------------------------------

  type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
  shared variable regfile : reg_array := (
    X"00000000", X"00000001", X"00000002", X"00000003",
    X"00000004", X"00000005", X"00000006", X"00000007",
    X"00000008", X"00000009", X"0000000a", X"0000000b",
    X"0000000c", X"0000000d", X"0000000e", X"0000000f",
    X"00000010", X"00000011", X"00000012", X"00000013",
    X"00000014", X"00000015", X"00000016", X"00000017",
    X"00000018", X"00000019", X"0000001a", X"0000001b",
    X"0000001c", X"0000001d", X"0000001e", X"0000001f"
  );

begin

-----------------------------------------------------------------
------------------- WRITE REGISTER-------------------------------
-----------------------------------------------------------------

  register_write: process (reset, mem_data, alu_result, clk)
    variable write_value: std_logic_vector(31 downto 0);
    variable addr1: std_logic_vector(4 downto 0);
    variable index: integer := 0;
	 
  begin
    if reset = '1' then
	
----------------------Initialize register file to orignal state on reset----------------

      regfile := (
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000008", X"00000009", X"0000000a", X"0000000b",
    X"0000000c", X"0000000d", X"0000000e", X"0000000f",
    X"00000010", X"00000011", X"00000012", X"00000013",
    X"00000014", X"00000015", X"00000016", X"00000017",
    X"00000018", X"00000019", X"0000001a", X"0000001b",
    X"0000001c", X"0000001d", X"0000001e", X"0000001f"
      );
		
    elsif rising_edge(clk) then
	 
------------------------Select data to be written to the register file---------------------
 
      if memtoreg = '1' then
        write_value := mem_data;
      else
        write_value := alu_result;
      end if;
		
------------------------Select the destination register address------------------------------
     
      if regdst = '0' then
        addr1 := instruction(20 downto 16);
      else
        addr1 := instruction(15 downto 11);
      end if;
		
------------------------Write data to the selected register address--------------------------
 
      if regwrite = '1' then
        index := to_integer(unsigned(addr1));
        regfile(index) := write_value;
      end if;
    end if;
  end process register_write;

  
-------------------------------------------------------------
-------------------READ REGISTER-----------------------------
-------------------------------------------------------------

	 register_read: process(instruction)
    variable rt, rs, rd: integer range 0 to 31;
    variable imm: std_logic_vector(31 downto 0);
  begin
  
------------------------- Extract source, target, and destination register addresses---------

    rs := to_integer(unsigned(instruction(25 downto 21)));
    rt := to_integer(unsigned(instruction(20 downto 16)));
    rd := to_integer(unsigned(instruction(15 downto 11)));
	 
------------------------- Output the register values------------------------------------------
	 
    reg_rs <= regfile(rs);
    reg_rt <= regfile(rt);
    reg_rd <= regfile(rd);
   

-------------------------- Extract immediate value from the instruction------------------------
	 
    imm(15 downto 0) := instruction(15 downto 0);
	 
-------------------------- Sign-extend the immediate value-------------------------------------
	 
    if instruction(15) = '1' then
      imm(31 downto 16) := x"ffff"; --Negative value of immediate
    else
      imm(31 downto 16) := x"0000"; --Positive value of immediate
    end if;
	 
---------------------------- Output the immediate value-----------------------------------------
    immediate <= imm;
----------------------------- Output the jump address--------------------------------------------

    jump_add <= "000000" & instruction(25 downto 0);
	 
  end process register_read;
end behv;
