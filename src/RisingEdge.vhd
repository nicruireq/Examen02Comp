----------------------------------------------------------------------------------
-- Engineer: 		 Nicolás Ruiz Requejo
-- 
-- Create Date:    20:10:04 11/11/2017 
-- Design Name: 
-- Module Name:    RisingEdge - Behavioral 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	RisingEdge.vhd  -- This file is part of Examen02Comp
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

entity RisingEdge is
    Port ( Reset : in  STD_LOGIC;
           Push : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Pulse : out  STD_LOGIC);
end RisingEdge;

architecture Behavioral of RisingEdge is
	signal RegisteredPush : std_logic;
	signal PreviousPush : std_logic;
begin
	
	-- Syncronizes the input "push"
	SincPush: process(Clk, Reset)
	begin
		if Reset = '1' then
			RegisteredPush <= '0';
		elsif rising_edge(Clk) then
			RegisteredPush <= Push;
		end if;
	end process SincPush;
	
	-- Stores "PreviousPush" (FFD)
	StorePrevPush: process(CLK, Reset)
	begin
		if Reset = '1' then
			PreviousPush <= '0';
		elsif rising_edge(CLK) then
			PreviousPush <= RegisteredPush;
		end if;
	end process StorePrevPush;
	
	-- COMBINATIONAL CIRCUIT
	-- compares Push and PreviousPush
	
	Pulse <= '1' when PreviousPush = '0' and RegisteredPush = '1'
					 else '0';

end Behavioral;

