----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolás Ruiz Requejo
-- 
-- Create Date:    12:46:37 01/22/2018 
-- Design Name: 
-- Module Name:    RAM16x10 - Behavioral 
-- Project Name: 	 Examen02
-- Target Devices: 
-- Tool versions: 
-- Description: 	 describes a read/write memory of 16x4 bits
--						 with asynchronous reading
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	RAM16x10.vhd  -- This file is part of Examen02Comp
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
use IEEE.NUMERIC_STD.ALL;

entity RAM16x10 is
    Port ( CLK : in  STD_LOGIC;
           dataIn : in  STD_LOGIC_VECTOR (9 downto 0);
           address : in  STD_LOGIC_VECTOR (3 downto 0);
           we : in  STD_LOGIC;
           dataOut : out  STD_LOGIC_VECTOR (9 downto 0));
end RAM16x10;

architecture Behavioral of RAM16x10 is

	type ramType is array(15 downto 0) of std_logic_vector(9 downto 0);
	-- default data of ram 
	signal ram : ramType := ("0000000001","0000000000","0000000000","0000000011",
									 "0000000010","0000000000","0000000000","0000000000",
									 "0000000000","1101010000","1011010100","1000110100",
									 "0011101100","0100011100","0001111100","0001100011"
									);
begin
	
	process(Clk)
	begin
		if rising_edge(Clk) then
			-- synchronous write enable
			if we = '1' then
				-- write in address position the data in
				ram(to_integer(unsigned(address))) <= dataIn;
			end if;
		end if;
	end process;
	
	-- asynchronous reading
	dataOut <= ram(to_integer(unsigned(address)));

end Behavioral;

