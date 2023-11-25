-------------------------------------------------------------------------------
-- File	      : substitution_layer.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-03
-- Last update: 2022-11-08
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception de la couche de substituion Ps
-- Entrées: state_i
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

entity substitution_layer is

	port(
			state_i : in type_state;
			state_o : out type_state);
		
end substitution_layer;

architecture substitution_layer_arch of substitution_layer is
	component sbox port (
			data_i : in bit5;
			data_o : out bit5);
	end component;
	
begin
	
-- la couche de substitution utilise la sbox et converti les 64 colonnes de 5 bits de sa sortie en 5 lignes (mots) de 64 bits.
		GEN : for i in 0 to 63 generate
			ps : sbox port map(
			-- la sbox prend en entrée l'état
				data_i(4) => state_i(0)(i),
				data_i(3) => state_i(1)(i),
				data_i(2) => state_i(2)(i),
				data_i(1) => state_i(3)(i),
				data_i(0) => state_i(4)(i),
				
				-- la sortie de la couche de substitution est la conversion en ligne de la sortie de la sbox
				data_o(4) => state_o(0)(i),
				data_o(3) => state_o(1)(i),
				data_o(2) => state_o(2)(i),
				data_o(1) => state_o(3)(i),
				data_o(0) => state_o(4)(i)
				);				
		end generate GEN;
	
end substitution_layer_arch;

library LIB_RTL;
configuration substitution_layer_conf of substitution_layer is
	for substitution_layer_arch
		for GEN
			for all : sbox
				use entity LIB_RTL.sbox(sbox_arch);
			end for;
		end for;
	end for;
end substitution_layer_conf;
