----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolas Ruiz Requejo
-- 
-- Create Date:    12:27:05 01/22/2018 
-- Design Name: 
-- Module Name:    RegN - Behavioral 
-- Project Name: 	 Examen02
-- Target Devices: 
-- Tool versions: 
-- Description: 	 describes parallel input/output register of n bits.
--						  
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	RegN.vhd  -- This file is part of Examen02Comp
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

entity RegN is
	 generic(n : integer := 1);
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR (n-1 downto 0);
           Q : out  STD_LOGIC_VECTOR (n-1 downto 0));
end RegN;

architecture Behavioral of RegN is
begin

	registerN:
	process (CLK, RESET)
	begin
		-- asynchronous reset
		if RESET = '1' then
			Q <= (others => '0');
		elsif rising_edge(CLK) then
			-- synchronous enable
			if enable = '1' then
				-- load input data
				Q <= D;
			end if;
		end if;
	end process registerN;

end Behavioral;

