----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolas Ruiz Requejo
-- 
-- Create Date:    20:04:20 01/25/2018 
-- Design Name: 
-- Module Name:    ControlUnit - Behavioral 
-- Project Name: 	 Examen02
-- Target Devices: 
-- Tool versions: 
-- Description: 	control unit for MicroArchitecture
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	ControlUnit.vhd  -- This file is part of Examen02Comp
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

entity ControlUnit is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
			  push : in STD_LOGIC;
           opCode : in  STD_LOGIC_VECTOR (2 downto 0);
           FZOut : in  STD_LOGIC;
           segmentViolation : in  STD_LOGIC;
           controlBus : out  STD_LOGIC_VECTOR (19 downto 0));
end ControlUnit;

architecture Behavioral of ControlUnit is
	type States is (Idle, CheckPC, EndCodeSegment, LoadInst,
						 Decode, CheckDir, WritePC, SegmentViolationException,
						 LoadAddress, MovB, LoadA, MovA, WBMem, ReadRegisters,
						 Add, WBReg, Sub, ReadImm);
	-- saves the state
	signal nextState : States;
	-- control words for each state
	constant cwIdle : std_logic_vector(19 downto 0) := "00000000000000000000";
	constant cwCheckPC : std_logic_vector(19 downto 0) := "00000010000000000000";
   constant cwEndCodeSegment : std_logic_vector(19 downto 0) := "11000000000000000001";
	constant cwLoadInst : std_logic_vector(19 downto 0) := "00100001000000000000";
	constant cwDecode : std_logic_vector(19 downto 0) := "00000000000000000000";
	constant cwCheckDir : std_logic_vector(19 downto 0) := "00001110000000000000";
	constant cwWritePC : std_logic_vector(19 downto 0) := "00110000000000000000";
	constant cwSegmentViolationException : std_logic_vector(19 downto 0) := "11000000000000000010";
	constant cwLoadAddress : std_logic_vector(19 downto 0) := "00000000001000100000";
	constant cwMovB : std_logic_vector(19 downto 0) := "00000000000010000100";
	constant cwLoadA : std_logic_vector(19 downto 0) := "00000000000100000000";
	constant cwMovA : std_logic_vector(19 downto 0) := "00000000000010000000";
	constant cwWBMem : std_logic_vector(19 downto 0) := "00000000100000000000";
	constant cwReadRegisters : std_logic_vector(19 downto 0) := "00000000001100000000";
	constant cwAdd : std_logic_vector(19 downto 0) := "00000000000011001000";
	constant cwWBReg : std_logic_vector(19 downto 0) := "00000000010000000000";
	constant cwSub : std_logic_vector(19 downto 0) := "00000000000011001100";
	constant cwReadImm : std_logic_vector(19 downto 0) := "00000000001100010000";
	--
begin

	-- this process choose the correct
	-- next state
	selectState:
	process(CLK, RESET)
	begin
		if RESET = '1' then
			nextState <= Idle;
		elsif rising_edge(CLK) then
			case nextState is
				-- state "Idle"
				when Idle =>
					if push = '1' then
						nextState <= CheckPC;
					end if;
				-- state "CheckPC"
				when CheckPC =>
					if (push = '1') then
						-- evaluate if there is segment violation
						if (segmentViolation = '1') then
							nextState <= EndCodeSegment;
						else
							nextState <= LoadInst;
						end if;
					end if;
				-- state "EndCodeSegment"
				when EndCodeSegment =>
					if (push = '1') then
						nextState <= Idle;
					end if;
				-- state "LoadInst"
				when LoadInst =>
					if (push = '1') then
						nextState <= Decode;
					end if;
				-- state "Decode"
				when Decode =>
					if push = '1' then
						-- evaluate (opCode,FZ)
						case opCode is
							-- "beq" instruction
							when "110" =>
								if (FZOut = '0') then
									nextState <= CheckPC;
								else
									nextState <= CheckDir;
								end if;
							-- "ld" and "st" instructions
							when "000" | "001" =>
								nextState <= CheckDir;
							-- "add" and "sub" instructions
							when "010" | "011" =>
								nextState <= ReadRegisters;
							-- "inc" and "dec" instructions
							when "100" | "101" =>
								nextState <= ReadImm;
							when others =>
								nextState <= Idle;
						end case;
						--
					end if;
				-- state "CheckDir"
				when CheckDir =>
					if push = '1' then
						-- evaluate (segmentViolation)
						if segmentViolation = '1' then
							nextState <= SegmentViolationException;
						else -- segmentViolation = '0'
							-- evaluate (opCode)
							case opCode is
							   -- "beq" instruction
								when "110" =>
									nextState <= WritePC;
								-- "ld" instruction
								when "000" =>
									nextState <= LoadAddress;
								-- "st" instruction
								when "001" =>
									nextState <= LoadA;
								when others =>
									nextState <= Idle;
							end case;
							--
						end if;
						--
					end if;
				-- state "WritePC"
				when WritePC =>
					if (push = '1') then
						nextState <= LoadInst;
					end if;
				-- state "SegmentViolationException"
				when SegmentViolationException =>
					if (push = '1') then
						nextState <= Idle;
					end if;
				-- state "LoadAddress"
				when LoadAddress =>
					if (push = '1') then
						nextState <= MovB;
					end if;
				-- state "MovB"
				when MovB =>
					if (push = '1') then
						nextState <= WBReg;
					end if;
				-- state "LoadA"
				when LoadA =>
					if (push = '1') then
						nextState <= MovA;
					end if;
				-- state "MovA"
				when MovA =>
					if (push = '1') then
						nextState <= WBMem;
					end if;
				-- state "WBMem"
				when WBMem =>
					if (push <= '1') then
						nextState <= CheckPC;
					end if;
				-- state "ReadRegisters"
				when ReadRegisters =>
					if (push = '1') then
						-- evaluate (opCode)
						case opCode is
							-- "add" instruction
							when "010" =>
								nextState <= Add;
							-- "sub" instruction
							when "011" =>
								nextState <= Sub;
							when others =>
								nextState <= Idle;
						end case;
						--
					end if;
				-- state "Add"
				when Add =>
					if (push = '1') then
						nextState <= WBReg;
					end if;
				-- state "Sub"
				when Sub =>
					if (push = '1') then
						nextState <= WBReg;
					end if;
				-- state "WBReg"
				when WBReg =>
					if (push = '1') then 
						nextState <= CheckPC;
					end if;
				-- state "ReadImm"
				when ReadImm =>
					if (push = '1') then
						-- evaluate (opCode)
						case opCode is
							-- "inc" instruction
							when "100" =>
								nextState <= Add;
							-- "dec" instruction
							when "101" =>
								nextState <= Sub;
							when others =>
								nextState <= Idle;
						end case;
					end if;
				when others =>
					nextState <= Idle;
			end case;
			--
		end if;
		--
	end process selectState;
	
	-- assign control signals for control bus
	-- of microarchitecture in each state
	with nextState select
		controlBus <= cwIdle when Idle,
						  cwCheckPC when CheckPC,
						  cwEndCodeSegment when EndCodeSegment,
						  cwLoadInst when LoadInst,
						  cwDecode when Decode,
						  cwCheckDir when CheckDir,
						  cwWritePC when WritePC,
						  cwSegmentViolationException when SegmentViolationException,
						  cwLoadAddress when LoadAddress,
						  cwMovB when MovB,
						  cwLoadA when LoadA,
						  cwMovA when MovA,
						  cwWBMem when WBMem,
						  cwReadRegisters when ReadRegisters,
						  cwAdd when Add,
						  cwWBReg when WBReg,
						  cwSub when Sub,
						  cwReadImm when ReadImm,
						  cwIdle when others;

end Behavioral;
