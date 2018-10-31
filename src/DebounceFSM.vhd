----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:43:32 01/10/2018 
-- Design Name: 
-- Module Name:    DebounceFSM - Behavioral 
-- Project Name: 
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
--	DebounceFSM.vhd  -- This file is part of Examen02Comp
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

entity DebounceFSM is
    Port ( CLK : in  STD_LOGIC;
           Push : in  STD_LOGIC;
           Flag_Timer : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           EnableTimer : out  STD_LOGIC;
           FilteredPush : out  STD_LOGIC);
end DebounceFSM;

architecture Behavioral of DebounceFSM is
	type RisingEdge_States is (inic,S0,S01,espera);
	signal Next_State: RisingEdge_States ;
begin

Process (RESET, CLK)
begin
	if RESET = '1' then
		Next_State <= inic; -- INICIO CON RESET
	elsif rising_edge(CLK) then
		case Next_State is
			when inic => 
				if Push= '0' then
					Next_State <= S0; --llega "0-"
				else
					Next_State <= inic;
				end if;
			when S0 => 
				if Push = '1' then
					Next_State <= S01; --llega "01"
				else
					Next_State <= S0;
				end if;
			when S01 => 
				Next_State <= espera; --"0" para "0-"
			when espera =>
				if Flag_Timer = '1' then
					Next_State <= inic;
				else
					Next_State <= espera;
				end if;
		end case;
	end if;
end process;

FilteredPush <= '1' when Next_State = S01 else '0';
EnableTimer <= '1' when Next_State = espera else '0';

end Behavioral;

