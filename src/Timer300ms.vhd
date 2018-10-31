----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:33:26 01/10/2018 
-- Design Name: 
-- Module Name:    Timer300ms - Behavioral 
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
--	Timer300ms.vhd  -- This file is part of Examen02Comp
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

entity Timer300ms is
    Port ( CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           End300ms : out  STD_LOGIC;
           Enable : in  STD_LOGIC);
end Timer300ms;

architecture Behavioral of Timer300ms is
		constant EndCount : integer := 15000000;
		signal Count : integer range 0 to EndCount;
begin

	process(CLK, Reset)
	begin
		if Reset = '1' then
			Count <= 0;
			End300ms <= '0';
		elsif rising_edge(CLK) then
			if Enable = '1' then
				if Count = EndCount - 1 then
					Count <= 0;
					End300ms <= '1';
				else 
					Count <= Count + 1;
					End300ms <= '0';
				end if;
			end if;
		end if;
	end process;
end Behavioral;

