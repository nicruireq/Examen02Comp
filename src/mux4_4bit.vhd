----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolás Ruiz Requejo
-- 
-- Create Date:    10:45:40 11/22/2017 
-- Design Name: 
-- Module Name:    mux4_4bit - Behavioral 
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
--	mux4_4bit.vhd  -- This file is part of Examen02Comp
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

entity mux4_4bit is
    Port ( I0 : in  STD_LOGIC_VECTOR (3 downto 0);
           I1 : in  STD_LOGIC_VECTOR (3 downto 0);
           I2 : in  STD_LOGIC_VECTOR (3 downto 0);
           I3 : in  STD_LOGIC_VECTOR (3 downto 0);
           Sel : in  STD_LOGIC_VECTOR (1 downto 0);
           F_Out : out  STD_LOGIC_VECTOR (3 downto 0));
end mux4_4bit;

architecture Behavioral of mux4_4bit is

begin

	with Sel select
		F_Out <= I0 when "00",
					I1 when "01",
					I2 when "10",
					I3 when "11",
					"0000" when others;

end Behavioral;

