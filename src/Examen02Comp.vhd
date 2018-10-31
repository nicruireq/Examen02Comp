----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolas Ruiz Requejo
-- 
-- Create Date:    23:21:11 01/25/2018 
-- Design Name: 
-- Module Name:    Examen02Comp - Behavioral 
-- Project Name: 	 Examen02
-- Target Devices: 
-- Tool versions: 
-- Description:   Interconnection between the microarchitecture 
--						and the unit of controlled
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	Examen02Comp.vhd  -- This file is part of Examen02Comp
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

entity Examen02Comp is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           push : in  STD_LOGIC;
           addressRAM : out  STD_LOGIC_VECTOR (3 downto 0);
           regAOut : out  STD_LOGIC_VECTOR (3 downto 0);
           regBOut : out  STD_LOGIC_VECTOR (3 downto 0);
           regOOut : out  STD_LOGIC_VECTOR (3 downto 0);
           regInstOut : out  STD_LOGIC_VECTOR (9 downto 0);
           opCode : out  STD_LOGIC_VECTOR (2 downto 0);
           FZOut : out  STD_LOGIC;
           segmentViolationLine : out  STD_LOGIC;
           endOfCodeLine : out  STD_LOGIC);
end Examen02Comp;

architecture Behavioral of Examen02Comp is
	
	COMPONENT ControlUnit
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
		push : IN std_logic;
		opCode : IN std_logic_vector(2 downto 0);
		FZOut : IN std_logic;
		segmentViolation : IN std_logic;          
		controlBus : OUT std_logic_vector(19 downto 0)
		);
	END COMPONENT;
	
	COMPONENT MicroArchitecture
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
		RST : in STD_LOGIC;
		selRst : in STD_LOGIC;
		LPC : IN std_logic;
		selPC : IN std_logic;
		selComp : IN std_logic;
		checkMode : IN std_logic;
		LMAR : IN std_logic;
		LIR : IN std_logic;
		WE : IN std_logic;
		RW : IN std_logic;
		LB : IN std_logic;
		LA : IN std_logic;
		LO : IN std_logic;
		LFZ : IN std_logic;
		selBSrc : IN std_logic_vector(1 downto 0);
		aluOp : IN std_logic_vector(1 downto 0);          
		addressRAM : OUT std_logic_vector(3 downto 0);
		regAOut : OUT std_logic_vector(3 downto 0);
		regBOut : OUT std_logic_vector(3 downto 0);
		regOOut : OUT std_logic_vector(3 downto 0);
		regInstOut : OUT std_logic_vector(9 downto 0);
		opCode : OUT std_logic_vector(2 downto 0);
		FZOut : OUT std_logic;
		segmentViolationLine : OUT std_logic
		);
	END COMPONENT;
	
	signal sigOpCode : std_logic_vector(2 downto 0);
	signal sigFZ : std_logic;
	signal sigControlBus : std_logic_vector(19 downto 0);
	signal sigSegmentV : std_logic;
	-- signals to filter control signals (of registers)
	-- from control unit with push
	signal filterLPC, filterLMAR, filterLIR, 
			 filterRW, filterLB, filterLA, filterLO, 
			 filterLFZ : std_logic;
	
begin

	instControlUnit: 
	ControlUnit PORT MAP(
		CLK => CLK,
		RESET => RESET,
		push => push,
		opCode => sigOpCode,
		FZOut => sigFZ,
		segmentViolation => sigSegmentV,
		controlBus => sigControlBus
	);
	
	-- in order to ensure that only with a rising edge
	-- of the push control signals shall be assigned
	-- and so a register can't be updated several times
	-- during a control state
	filterLPC <= sigControlBus(17) and push;
	filterLMAR <= sigControlBus(13) and push;
	filterLIR <= sigControlBus(12) and push;
	filterRW <= sigControlBus(10) and push;
	filterLB <= sigControlBus(9) and push;
	filterLA <= sigControlBus(8)and push;
	filterLO <= sigControlBus(7)and push;
	filterLFZ <= sigControlBus(6)and push;

	instMicroArchitecture: 
	MicroArchitecture PORT MAP(
		CLK => CLK,
		RESET => RESET,
		RST => sigControlBus(19),
		selRst => sigControlBus(18),
		LPC => filterLPC,								
		selPC => sigControlBus(16),
		selComp => sigControlBus(15),
		checkMode => sigControlBus(14),
		LMAR => filterLMAR,							
		LIR => filterLIR,							
		WE => sigControlBus(11), 
		RW => filterRW,								
		LB => filterLB,								
		LA => filterLA,								
		LO => filterLO,								
		LFZ => filterLFZ,								
		selBSrc => sigControlBus(5 downto 4),
		aluOp => sigControlBus(3 downto 2),
		addressRAM => addressRAM,
		regAOut => regAOut,
		regBOut => regBOut,
		regOOut => regOOut,
		regInstOut => regInstOut,
		opCode => sigOpCode,
		FZOut => sigFZ,
		segmentViolationLine => sigSegmentV
	);
	
	-- connect outputs of Examen02Comp
	opCode <= sigOpCode;
	FZOut <= sigFZ;
	segmentViolationLine <= sigControlBus(1);
	endOfCodeLine <= sigControlBus(0);

end Behavioral;
