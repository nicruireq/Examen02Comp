----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nicolas Ruiz Requejo
-- 
-- Create Date:    10:49:02 10/18/2017 
-- Design Name: 
-- Module Name:    Disp7Seg - Behavioral 
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
--	Disp7Seg.vhd  -- This file is part of Examen02Comp
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Disp7Seg is
    Port ( Hex : in  STD_LOGIC_VECTOR (3 downto 0);
           Select_Disp : in  STD_LOGIC_VECTOR (1 downto 0);
           Seg : out  STD_LOGIC_VECTOR (6 downto 0);
           Anode : out  STD_LOGIC_VECTOR (3 downto 0));
end Disp7Seg;

architecture Behavioral of Disp7Seg is
begin
	
   Anode <= "1110" when Select_Disp = "00" else
            "1101" when Select_Disp = "01" else
            "1011" when Select_Disp = "10" else
				"0111" when Select_Disp = "11" else
				"1111";
	
	Seg <= "0000001" when Hex = "0000" else
			 "1001111" when Hex = "0001" else
			 "0010010" when Hex = "0010" else
			 "0000110" when Hex = "0011" else
			 "1001100" when Hex = "0100" else
			 "0100100" when Hex = "0101" else
			 "0100000" when Hex = "0110" else
			 "0001111" when Hex = "0111" else
			 "0000000" when Hex = "1000" else
			 "0001100" when Hex = "1001" else
			 "0001000" when Hex = "1010" else
			 "1100000" when Hex = "1011" else
			 "0110001" when Hex = "1100" else
			 "1000010" when Hex = "1101" else
			 "0110000" when Hex = "1110" else
			 "0111000" when Hex = "1111" else
			 "1111111";

end Behavioral;

