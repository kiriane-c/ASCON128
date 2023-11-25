-------------------------------------------------------------------------------
-- File	      : diffusion_layer.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-03
-- Last update: 2022-11-03
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception de la couche de diffusion Pl
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

entity diffusion_layer is

	port(
		state_i : in type_state;	-- state sur 320 bits
		state_o : out type_state);

end diffusion_layer;

architecture diffusion_layer_arch of diffusion_layer is
	
	begin
	
	-- la sortie de cette couche est une fonction de somme définie par des opérations de xor
	-- on opère également des décalages de bits
		state_o(0) <= state_i(0) xor (state_i(0)(18 downto 0))&(state_i(0)(63 downto 19)) xor (state_i(0)(27 downto 0))&(state_i(0)(63 downto 28));
		state_o(1) <= state_i(1) xor (state_i(1)(60 downto 0))&(state_i(1)(63 downto 61)) xor (state_i(1)(38 downto 0))&(state_i(1)(63 downto 39));
		state_o(2) <= state_i(2) xor (state_i(2)(0))&(state_i(2)(63 downto 1)) xor (state_i(2)(5 downto 0))&(state_i(2)(63 downto 6));
		state_o(3) <= state_i(3) xor (state_i(3)(9 downto 0))&(state_i(3)(63 downto 10)) xor (state_i(3)(16 downto 0))&(state_i(3)(63 downto 17));
		state_o(4) <= state_i(4) xor (state_i(4)(6 downto 0))&(state_i(4)(63 downto 7)) xor (state_i(4)(40 downto 0))&(state_i(4)(63 downto 41));

end diffusion_layer_arch;
