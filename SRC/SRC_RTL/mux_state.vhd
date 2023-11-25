-------------------------------------------------------------------------------
-- File	      : mux_state.vhd
-- Author     : Jean-Baptiste RIGAUD  <rigaud@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-08-25
-- Last update: 2022-08-26
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du multixpleur
-- Entrées: sel_i, data1_i, data2_i
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

entity mux_state is

	port(
			sel_i : in std_logic;
			data1_i : in type_state;
			data2_i : in type_state;
			data_o : out type_state);
		
end mux_state;

architecture mux_state_arch of mux_state is

	signal state_s : type_state;

begin
	
	data_o <= data1_i when sel_i = '0' else
						data2_i;

end mux_state_arch;
