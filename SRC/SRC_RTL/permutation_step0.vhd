-------------------------------------------------------------------------------
-- File	      : permutation_step_0
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-10
-- Last update: 2022-11-16
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception de la permutation de base
-- Entrées: data_sel_i, resetb_i, clock_i, en_reg_state_i, round_i, state_i
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

entity permutation_step0 is

	port(
			data_sel_i : in std_logic;
			resetb_i : in std_logic;
			clock_i : in std_logic;
			en_reg_state_i : in std_logic;
			round_i : in bit4;
			state_i : in type_state;
			state_o : out type_state);
		
end permutation_step0;

architecture permutation_step0_arch of permutation_step0 is

	-- utilise les composants définis ci-dessous
	component mux_state port(
		sel_i : in std_logic;
		data1_i : in type_state;
		data2_i : in type_state;
		data_o : out type_state);
	end component;

	component state_register port(
		resetb_i : in std_logic;
		clock_i : in std_logic;
		en_reg_state_i : in std_logic;
		data_i : in type_state;
		data_o : out type_state);
	end component;

	component constant_addition port(
		state_i : in type_state;
		counter_i : in bit4;
		state_o : out type_state);
	end component;
	
	component substitution_layer port(
		state_i : in type_state;
		state_o : out type_state);
	end component;
	
	component diffusion_layer port(
		state_i : in type_state;
		state_o : out type_state);
	end component;
	
	signal state_mux_s, state_pc_s, state_ps_s, state_pl_s, state_pem_s : type_state;
	
begin		

		-- l'entrée du mux est le state et déterminée par sel_i
		mux : mux_state port map(
			sel_i => data_sel_i,
			data1_i => state_i,
			data2_i => state_pem_s,
			data_o => state_mux_s);
		
		-- l'entrée de l'addition de constante est la sortie du mux
		add : constant_addition port map(
			state_i => state_mux_s,
			counter_i => round_i,
			state_o => state_pc_s);
			
		-- l'entrée de la couche de substitution est la sortie de l'addition de constante
		sub : substitution_layer port map(
			state_i => state_pc_s,
			state_o => state_ps_s);
			
		-- l'entrée de la couche de diffusion est la sortie de la couche de substitution
		diff : diffusion_layer port map(
			state_i => state_ps_s,
			state_o => state_pl_s);
			
		-- le registre mémorise la sortie de la couche de diffusion et retourne l'état au mux
		reg : state_register port map(
			resetb_i => resetb_i,
			clock_i => clock_i,
			en_reg_state_i => en_reg_state_i,
			data_i => state_pl_s,
			data_o => state_pem_s);
	
	state_o <= state_pem_s;	-- la sortie est la sortie de la permutation
	
end permutation_step0_arch;

library LIB_RTL;
configuration permutation_step0_conf of permutation_step0 is
	for permutation_step0_arch
			for all : mux_state
				use entity LIB_RTL.mux_state(mux_state_arch);
			end for;
			for all : constant_addition
				use entity LIB_RTL.constant_addition(constant_addition_arch);
			end for;
			for all : substitution_layer
				use configuration LIB_RTL.substitution_layer_conf;
			end for;
			for all : diffusion_layer
				use entity LIB_RTL.diffusion_layer(diffusion_layer_arch);
			end for;
			for all : state_register
				use entity LIB_RTL.state_register(state_register_arch);
			end for;
	end for;
end permutation_step0_conf;
