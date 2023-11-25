-------------------------------------------------------------------------------
-- File	      : diffusion_layer_tb.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-03
-- Last update: 2022-11-07
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du testbench de la couche de diffusion
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

entity diffusion_layer_tb is
end entity diffusion_layer_tb;

architecture diffusion_layer_tb_arch of diffusion_layer_tb is
	component diffusion_layer port(
		state_i : type_state;
		state_o : out type_state);
	end component;


	signal state_is, state_os : type_state;

begin
	DUT : diffusion_layer port map(
		state_i => state_is,
		state_o => state_os);
	
	--stimuli
	-- le stimuli est la sortie de la couche de substitution
	state_is <= (x"8849060f0c0d0eff", x"80410e05040506f7", x"ffffffffffffff0f", x"80400406000000f0", x"0808080a08080808");

end diffusion_layer_tb_arch;

configuration diffusion_layer_tb_conf of diffusion_layer_tb is
	for diffusion_layer_tb_arch
		for DUT : diffusion_layer
			use entity LIB_RTL.diffusion_layer(diffusion_layer_arch);
		end for;
	end for;
end diffusion_layer_tb_conf;
