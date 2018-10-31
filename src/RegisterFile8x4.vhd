----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolas Ruiz Requejo
-- 
-- Create Date:    12:59:58 01/22/2018 
-- Design Name: 
-- Module Name:    RegisterFile8x4 - Behavioral 
-- Project Name: 	 Examen02
-- Target Devices: 
-- Tool versions: 
-- Description: 	 Describes register file of four bits eight registers 
--						 with two address inputs, two data output ports,
--						 one input data port, synchronous write enable
--						 and asynchronous reset
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	RegisterFile8x4.vhd  -- This file is part of Examen02Comp
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

entity RegisterFile8x4 is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           dirReg1 : in  STD_LOGIC_VECTOR (2 downto 0);
           dirReg2 : in  STD_LOGIC_VECTOR (2 downto 0);
           dataInReg2 : in  STD_LOGIC_VECTOR (3 downto 0);
           dataOutReg1 : out  STD_LOGIC_VECTOR (3 downto 0);
           dataOutReg2 : out  STD_LOGIC_VECTOR (3 downto 0);
           RW : in  STD_LOGIC);
end RegisterFile8x4;

architecture Behavioral of RegisterFile8x4 is
	
	component RegN
	generic(n : integer := 1);
	port(
			CLK : in std_logic;
			RESET : in std_logic;
			enable : in std_logic;
			D : in std_logic_vector(n-1 downto 0);          
			Q : out std_logic_vector(n-1 downto 0)
		  );
	end component;
	
	-- signals output of a 3:8 decoder to select
	-- the register to writing
	signal sigSelWRegs : std_logic_vector(7 downto 0);
			 
	-- signals to enable the register what is selected 
	-- to write
	signal sigEnRegs : std_logic_vector(7 downto 0);
			 
	type dataOutRegsType is array (7 downto 0) of std_logic_vector(3 downto 0);
	-- signal data output registers bus
	signal dataOutRegs : dataOutRegsType;

begin

	-- decode dirReg2 input to select what 
	-- register will be written
	with dirReg2 select
		sigSelWRegs <= "00000001" when "000",
							"00000010" when "001",
							"00000100" when "010",
							"00001000" when "011",
							"00010000" when "100",
							"00100000" when "101",
							"01000000" when "110",
							"10000000" when "111",
							"00000000" when others;
	
	-- identify what register is enabled to writing
	-- with decoded dirReg2 address and RW control signal
	enabling:
	for i in 0 to 7 generate
		sigEnRegs(i) <= sigSelWRegs(i) and RW;
	end generate enabling;

	-- instantiate eight registers, enables are
	-- selected from 'and operation' of decode writing address 
	-- and RW control signal
	instRegs:
	for i in 0 to 7 generate
		regs: RegN 
			generic map(n => 4) 
			port map(CLK, RESET, sigEnRegs(i), dataInReg2, dataOutRegs(i));
	end generate instRegs;
	
	-- select the correct outputs for dataOutReg1 port
	-- with first address port
	with dirReg1 select
		dataOutReg1 <= dataOutRegs(0) when "000",
							dataOutRegs(1) when "001",
							dataOutRegs(2) when "010",
							dataOutRegs(3) when "011",
							dataOutRegs(4) when "100",
							dataOutRegs(5) when "101",
							dataOutRegs(6) when "110",
							dataOutRegs(7) when "111",
							(others => '0') when others;
	
	-- select the correct outputs for dataOutReg1 port
	-- with second address port
	with dirReg2 select
		dataOutReg2 <= dataOutRegs(0) when "000",
							dataOutRegs(1) when "001",
							dataOutRegs(2) when "010",
							dataOutRegs(3) when "011",
							dataOutRegs(4) when "100",
							dataOutRegs(5) when "101",
							dataOutRegs(6) when "110",
							dataOutRegs(7) when "111",
							(others => '0') when others;

end Behavioral;

