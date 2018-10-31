----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolas Ruiz Requejo
-- 
-- Create Date:    04:41:53 01/26/2018 
-- Design Name: 
-- Module Name:    TOP_Examen02Comp - Behavioral 
-- Project Name:   Examen02
-- Target Devices: 
-- Tool versions: 
-- Description: 	 test Examen02Comp in Basys2,
--						 connections with Examen02Comp
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	TOP_Examen02Comp.vhd  -- This file is part of Examen02Comp
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

entity TOP_Examen02Comp is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           push : in  STD_LOGIC;
           Anode : out  STD_LOGIC_VECTOR (3 downto 0);
           Catode : out  STD_LOGIC_VECTOR (6 downto 0);
           FZOut : out  STD_LOGIC;
           opCode : out  STD_LOGIC_VECTOR (1 downto 0);
           regInst : out  STD_LOGIC_VECTOR (7 downto 0);
           segmentFlag : out  STD_LOGIC;
           enfOfCodeFlag : out  STD_LOGIC);
end TOP_Examen02Comp;

architecture Behavioral of TOP_Examen02Comp is
	
	COMPONENT Debounce
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
		Push : IN std_logic;          
		FilteredPush : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT Examen02Comp
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
		push : IN std_logic;          
		addressRAM : OUT std_logic_vector(3 downto 0);
		regAOut : OUT std_logic_vector(3 downto 0);
		regBOut : OUT std_logic_vector(3 downto 0);
		regOOut : OUT std_logic_vector(3 downto 0);
		regInstOut : OUT std_logic_vector(9 downto 0);
		opCode : OUT std_logic_vector(2 downto 0);
		FZOut : OUT std_logic;
		segmentViolationLine : OUT std_logic;
		endOfCodeLine : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT Display7seg_4ON
	PORT(
		Dato1 : IN std_logic_vector(3 downto 0);
		Dato2 : IN std_logic_vector(3 downto 0);
		Dato3 : IN std_logic_vector(3 downto 0);
		Dato4 : IN std_logic_vector(3 downto 0);
		CLK : IN std_logic;
		RESET : IN std_logic;          
		Anodo : OUT std_logic_vector(3 downto 0);
		Catodo : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;
	
	signal sigAddressRAM, sigRegA, sigRegB, sigRegO
			 : std_logic_vector(3 downto 0);
			 
	signal sigFilteredPush : std_logic;
	signal sigRegInst : std_logic_vector(9 downto 0);
	signal sigOpCode : std_logic_vector(2 downto 0);
begin
	
	-- in order to avoid oscillations
	-- by mechanical push-button and trigger
	-- control signals once per pulse
	filterPush: 
	Debounce PORT MAP(
		CLK => CLK,
		RESET => RESET,
		Push => push,
		FilteredPush => sigFilteredPush
	);

	instExamen02Comp: 
	Examen02Comp PORT MAP(
		CLK => CLK,
		RESET => RESET,
		push => sigFilteredPush,	
		addressRAM => sigAddressRAM,
		regAOut => sigRegA,
		regBOut => sigRegB,
		regOOut => sigRegO,
		regInstOut => sigRegInst,
		opCode => sigOpCode,
		FZOut => FZOut,
		segmentViolationLine => segmentFlag,
		endOfCodeLine => enfOfCodeFlag
	);
	
	regInst <= sigRegInst(7 downto 0);
	opCode <= sigOpCode(2 downto 1);
	
	-- addressRAM in AN4
	-- regA in AN3
	-- regB in AN2
	-- regO in AN1
	instDisplay7seg_4ON: 
	Display7seg_4ON PORT MAP(
		Dato1 => sigAddressRAM,
		Dato2 => sigRegA,
		Dato3 => sigRegB,
		Dato4 => sigRegO,
		CLK => CLK,
		RESET => RESET,
		Anodo => Anode,
		Catodo => Catode
	);

end Behavioral;

