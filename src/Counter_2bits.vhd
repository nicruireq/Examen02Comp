----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolás Ruiz Requejo
-- 
-- Create Date:    10:22:25 11/15/2017 
-- Design Name: 
-- Module Name:    Counter_2bits - Behavioral 
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
--	Counter_2bits.vhd  -- This file is part of Examen02Comp
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter_2bits is
    Port ( ENABLE : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (1 downto 0));
end Counter_2bits;

architecture Behavioral of Counter_2bits is
	signal cuenta : unsigned (1 downto 0);
begin
	
	process(CLK, RESET)
	begin
		if (RESET = '1') then
			cuenta <= "00";
		elsif rising_edge(CLK) then
			if ENABLE = '1' then
				cuenta <= cuenta + 1;
			end if;
		end if;
	end process;
	
	Q <= std_logic_vector(cuenta);

end Behavioral;

