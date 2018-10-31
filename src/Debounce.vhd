----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		Nicolás Ruiz Requejo
-- 
-- Create Date:    12:04:46 01/10/2018 
-- Design Name: 
-- Module Name:    Debounce - Behavioral 
-- Project Name: 	 Examen02
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	Debounce.vhd  -- This file is part of Examen02Comp
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

entity Debounce is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Push : in  STD_LOGIC;
           FilteredPush : out  STD_LOGIC);
end Debounce;

architecture Behavioral of Debounce is

	COMPONENT DebounceFSM
	PORT(
		CLK : IN std_logic;
		Push : IN std_logic;
		Flag_Timer : IN std_logic;
		RESET : IN std_logic;          
		EnableTimer : OUT std_logic;
		FilteredPush : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT Timer300ms
	PORT(
		CLK : IN std_logic;
		Reset : IN std_logic;
		Enable : IN std_logic;          
		End300ms : OUT std_logic
		);
	END COMPONENT;
	
	signal Signal_Enable_Timer : std_logic;
	signal Signal_End300ms : std_logic;

begin

	Inst_DebounceFSM: DebounceFSM PORT MAP(
		CLK => CLK,
		Push => Push,
		Flag_Timer => Signal_End300ms,
		RESET => RESET,
		EnableTimer => Signal_Enable_Timer,
		FilteredPush => FilteredPush
	);
	
	Inst_Timer300ms: Timer300ms PORT MAP(
		CLK => CLK,
		Reset => RESET,
		End300ms => Signal_End300ms,
		Enable => Signal_Enable_Timer
	);

end Behavioral;

