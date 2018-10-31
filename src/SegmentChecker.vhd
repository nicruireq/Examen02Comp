----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolas Ruiz Requejo
-- 
-- Create Date:    16:09:03 01/22/2018 
-- Design Name: 
-- Module Name:    SegmentChecker - Behavioral 
-- Project Name:   Examen02
-- Target Devices: 
-- Tool versions: 
-- Description: 	 this unit operates to avoid possible
--						 addresses that cause segment violations 
--						 from LD, ST, BEQ instructions; and from 
--						 the program counter (PC). When segment 
--						 violation is detected segmenViolationFlag
--						 is activated in high
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	SegmentChecker.vhd  -- This file is part of Examen02Comp
--
--	Copyright (C) 2017-2018 Nicolas Ruiz Requejo
--
--  This file is part of Examen02Comp.
--
--  Examen02Comp is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  Examen02Comp is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with Examen02Comp.  If not, see <https://www.gnu.org/licenses/>.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SegmentChecker is
    Port ( opCode : in  STD_LOGIC_VECTOR (2 downto 0);
           dirInput : in  STD_LOGIC_VECTOR (3 downto 0);
			  checkMode : in STD_LOGIC;
           segmentLimit : in  STD_LOGIC_VECTOR (3 downto 0);
           segmentViolationFlag : out  STD_LOGIC;
           dirOutput : out  STD_LOGIC_VECTOR (3 downto 0));
end SegmentChecker;

architecture Behavioral of SegmentChecker is

begin
	-- Addresses can come from: program counter,
	-- to load a new instruction from memory into
	-- instructions register; from BEQ instruction,
   --	to change program counter content that shall be
   --	a code segment's memory address; from LD 
	-- and ST instructions to load/store data between
   --	registers and memory that shall be a data segment's
	-- memory address.
	
	-- checker process determine if there is to
	-- activate segment violation signal when come
	-- an address from program counter or instructions register.
	-- it's a combinational process
	checker: 
	process(dirInput, checkMode, opCode, segmentLimit)
	begin
		-- if enabled mode check program counter
		if checkMode = '0' then
			-- independently of operation code
			-- the memory address of new instruction
			-- to execute can't cross the limit of code segment
			-- then a line indicating end of code segment is up:
			if dirInput <= segmentLimit then
				segmentViolationFlag <= '0';
			else
				segmentViolationFlag <= '1';
			end if;
		else	-- if enabled mode check is ld, st and beq
			-- A data segment's address
			if dirInput > segmentLimit then
				case opCode is
					when "000" | "001" =>
						-- LD and ST instructions can only write
						-- in data segment's memory addresses
						segmentViolationFlag <= '0';
					when "110" =>
						-- BEQ instruction can't write memory
						-- addresses in program counter that
						-- corresponds to data segment
						segmentViolationFlag <= '1';
					when others =>
						-- it can't write in program counter
						-- a memory address that corresponds to 
						-- data segment
						segmentViolationFlag <= '1';
				end case;
			-- A code segment's address
			elsif dirInput <= segmentLimit then
				case opCode is
					when "000" | "001" =>
						-- LD and ST instructions can't write
						-- in code segment's memory addresses
						segmentViolationFlag <= '1';
					when others =>
						-- BEQ instruction trying to load jump
						-- address into program counter or an address
						-- from the program counter are operating in 
						-- the correct segment (code segment)
						segmentViolationFlag <= '0';
				end case;	
			end if;
		end if;
	end process checker;
	
	-- pass input address to output
	dirOutput <= dirInput;

end Behavioral;

