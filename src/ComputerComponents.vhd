--
--	Package File
--
--	Purpose: This package defines components of 
--		 FFD, RAM16X10, RegisterFile8x4, RegN and SegmentChecker
--
--	ComputerComponents.vhd  -- This file is part of Examen02Comp
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
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package ComputerComponents is
	-- component declarations
	component FFD is
    port ( 
		Clk : in  STD_LOGIC;
		RESET : in  STD_LOGIC;
		ENABLE : in  STD_LOGIC;
		D : in  STD_LOGIC;
      Q : out  STD_LOGIC
		); 
	end component;

	component RAM16x10
	port(
		CLK : IN std_logic;
		dataIn : IN std_logic_vector(9 downto 0);
		address : IN std_logic_vector(3 downto 0);
		we : IN std_logic;          
		dataOut : OUT std_logic_vector(9 downto 0)
		);
	end component;
	
	component RegisterFile8x4
	port(
		CLK : IN std_logic;
		RESET : IN std_logic;
		dirReg1 : IN std_logic_vector(2 downto 0);
		dirReg2 : IN std_logic_vector(2 downto 0);
		dataInReg2 : IN std_logic_vector(3 downto 0);
		RW : IN std_logic;          
		dataOutReg1 : OUT std_logic_vector(3 downto 0);
		dataOutReg2 : OUT std_logic_vector(3 downto 0)
		);
	end component;
	
	component RegN
	generic(n : integer := 1);
	port(
		CLK : IN std_logic;
		RESET : IN std_logic;
		enable : IN std_logic;
		D : IN std_logic_vector(n-1 downto 0);          
		Q : OUT std_logic_vector(n-1 downto 0)
		);
	end component;
	
	component SegmentChecker
	port(
		opCode : IN std_logic_vector(2 downto 0);
		dirInput : IN std_logic_vector(3 downto 0);
		checkMode : IN STD_LOGIC;
		segmentLimit : IN std_logic_vector(3 downto 0);          
		segmentViolationFlag : OUT std_logic;
		dirOutput : OUT std_logic_vector(3 downto 0)
		);
	end component;
	
end ComputerComponents;
