-------------------------------------------------------------------------------
-- File	      : state_register.vhd
-- Author     : Jean-Baptiste RIGAUD  <rigaud@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-08-25
-- Last update: 2022-08-26
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du multixpleur
-- Entrées: resetb_i, clock_i, en_reg_state_i, data_i
-- Sorties: data_o
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-10-24  1.0	rigaud	Created
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use lib_rtl.ascon_pack.all;

entity state_register is

	port(
		resetb_i : in std_logic;
		clock_i : in std_logic;
    en_reg_state_i : in  std_logic;
		data_i : in type_state;
		data_o : out type_state);
		
end entity state_register;

architecture state_register_arch of state_register is

	signal state_s : type_state;

begin

	seq0 : process (clock_i, resetb_i) is
 
  begin	 -- process seq_0
    if (resetb_i = '0') then		-- asynchronous reset (active low)
      state_s <= (others => (others => '0'));

    elsif (clock_i'event and clock_i = '1') then  -- rising clock edge
      if (en_reg_state_i = '1') then
				state_s <= data_i;
      else
				state_s <= state_s;
      end if;
    end if;
  end process seq0;

	data_o <= state_s;
	
end architecture state_register_arch;
