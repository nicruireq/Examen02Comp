----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolás Ruiz Requejo
-- 
-- Create Date:    01:57:18 11/17/2017 
-- Design Name: 
-- Module Name:    CLK_1KHz - Behavioral 
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
--	CLK_1KHz.vhd  -- This file is part of Examen02Comp
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

entity CLK_1KHz is
    Port ( CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Out_1KHz : out  STD_LOGIC);
end CLK_1KHz;

architecture Behavioral of CLK_1KHz is
	constant EndCount : integer := 50000;
	signal Count : integer range 0 to EndCount;
begin

	process(CLK, Reset)
	begin
		if Reset = '1' then
			Count <= 0;
			Out_1KHz <= '0';
		elsif rising_edge(CLK) then
			if Count = EndCount - 1 then
				Count <= 0;
				Out_1KHz <= '1';
			else 
				Count <= Count + 1;
				Out_1KHz <= '0';
			end if;
		end if;
	end process;
	
end Behavioral;

