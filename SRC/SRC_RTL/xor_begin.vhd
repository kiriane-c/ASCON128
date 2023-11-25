-------------------------------------------------------------------------------
-- File	      : xor_begin.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-16
-- Last update: 2022-11-21
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception de l'opération de xor du début
-- Entrées: state_i, data_i, en_xor_begin_i
-- Sorties: state_o
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-10-24  1.0	nguego	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use lib_rtl.ascon_pack.all;

entity xor_begin is

	port(
			state_i : in type_state;
			data_i : in bit64;
			en_xor_begin_i : in std_logic;	-- enable xor begin
			state_o : out type_state);
		
end xor_begin;

architecture xor_begin_arch of xor_begin is 

begin

		-- quand en_xor_begin_i vaut 1, le mot x0 est xor avec la donnée
		state_o(0) <= state_i(0) xor data_i when en_xor_begin_i = '1' else
									state_i(0);
										
		state_o(1) <= state_i(1);
		state_o(2) <= state_i(2);
		state_o(3) <= state_i(3);
		state_o(4) <= state_i(4);
		
end xor_begin_arch;
