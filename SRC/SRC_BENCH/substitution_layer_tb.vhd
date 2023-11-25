-------------------------------------------------------------------------------
-- File	      : substitution_layer_tb.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-03
-- Last update: 2022-11-03
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du tesbench de la couche de subsitution
-- Entrées: data_i
-- Sorties: data_o
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

entity substitution_layer_tb is
end entity substitution_layer_tb;

architecture substitution_layer_tb_arch of substitution_layer_tb is
	component substitution_layer port (
		state_i : type_state;
		state_o : out type_state);
	end component;

	signal state_is, state_os : type_state;

begin
	DUT : substitution_layer port map(
		state_i => state_is,
		state_o => state_os);
	
	--stimuli
	-- le stimuli est la sortie du bloc de l'addition de constante
	state_is(0) <= x"80400c0600000000";
	state_is(1) <= x"0001020304050607";
	state_is(2) <= x"08090a0b0c0d0eff";
	state_is(3) <= x"0001020304050607";
	state_is(4) <= x"08090a0b0c0d0e0f";

end substitution_layer_tb_arch;

configuration substitution_layer_tb_conf of substitution_layer_tb is
	for substitution_layer_tb_arch
		for DUT : substitution_layer
			use entity LIB_RTL.substitution_layer(substitution_layer_arch);
		end for;
	end for;
end substitution_layer_tb_conf;
