----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolas Ruiz Requejo
-- 
-- Create Date:    12:25:57 01/25/2018 
-- Design Name: 
-- Module Name:    TOP_MicroArch - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 	test for micro architecture in Basys2
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	TOP_MicroArch.vhd  -- This file is part of Examen02Comp
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

entity TOP_MicroArch is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
			  LPC : in STD_LOGIC;
			  --selPC : in STD_LOGIC_VECTOR(1 downto 0);
           selComp : in  STD_LOGIC;
           checkMode : in  STD_LOGIC;
			  LMAR : in  STD_LOGIC;
			  LIR : in  STD_LOGIC;
			  WE : in STD_LOGIC;
			  RW : in  STD_LOGIC;
           LB : in  STD_LOGIC;
			  LA : in  STD_LOGIC;
           LO : in  STD_LOGIC;
			  --LFZ : in  STD_LOGIC;
			  --selBSrc : in STD_LOGIC_VECTOR(1 downto 0);
			  --aluOp : in STD_LOGIC_VECTOR(1 downto 0);			  
           Anode : out  STD_LOGIC_VECTOR (3 downto 0);
           Catode : out  STD_LOGIC_VECTOR (6 downto 0);
           FZOut : out  STD_LOGIC;
           opCode : out  STD_LOGIC_VECTOR (1 downto 0);
           regInst : out  STD_LOGIC_VECTOR (7 downto 0);
           segmentFlag : out  STD_LOGIC);
end TOP_MicroArch;

architecture Behavioral of TOP_MicroArch is

	COMPONENT Debounce
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
		Push : IN std_logic;          
		FilteredPush : OUT std_logic
		);
	END COMPONENT;

	COMPONENT MicroArchitecture
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
		LPC : IN std_logic;
		selPC : IN std_logic_vector(1 downto 0);
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
	signal sigFilterLPC : std_logic;
	signal sigRegInst : std_logic_vector(9 downto 0);
	signal sigOpCode : std_logic_vector(2 downto 0);
begin

		filterLPC: 
		Debounce PORT MAP(
			CLK => CLK,
			RESET => RESET,
			Push => LPC,
			FilteredPush => sigFilterLPC 
		);
		
		Inst_MicroArchitecture: 
		MicroArchitecture PORT MAP(
			CLK => CLK,
			RESET => RESET,
			LPC => sigFilterLPC,
			selPC => "00",
			selComp => selComp,
			checkMode => checkMode,
			LMAR => LMAR,
			LIR => LIR,
			WE => WE,
			RW => RW,
			LB => LB,
			LA => LA,
			LO => LO,
			LFZ => '0',
			selBSrc => "10",
			aluOp => "01",
			addressRAM => sigAddressRAM,
			regAOut => sigRegA,
			regBOut => sigRegB,
			regOOut => sigRegO,
			regInstOut => sigRegInst,
			opCode => sigOpCode,
			FZOut => FZOut,
			segmentViolationLine => segmentFlag
		);

		regInst <= sigRegInst(7 downto 0);
		opCode <= sigOpCode(2 downto 1);

		Inst_Display7seg_4ON: 
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

