----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 	Nicolás Ruiz Requejo
-- 
-- Create Date:    18:21:12 11/11/2017 
-- Design Name: 
-- Module Name:    FFD - Behavioral 
-- Project Name:   Examen02
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
--	FFD.vhd  -- This file is part of Examen02Comp
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

-- Flip-flop D with synchronous enable input and
--					asynchronous RESET input, both
--					active in high

entity FFD is
    Port ( Clk : in  STD_LOGIC;
			  RESET : in  STD_LOGIC;
			  enable : in  STD_LOGIC;
			  D : in  STD_LOGIC;
           Q : out  STD_LOGIC
			 ); 
end FFD;

architecture Behavioral of FFD is

begin

	process(Clk, RESET)
	begin
		-- asynchronous reset, clear
		if RESET = '1' then
			Q <= '0';
		elsif rising_edge(Clk) then
			-- synchronous enable
			if (enable = '1') then
				-- load input bit data
				Q <= D;
			end if;
		end if;
	end process;

end Behavioral;

