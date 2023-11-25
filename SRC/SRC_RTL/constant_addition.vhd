-------------------------------------------------------------------------------
-- File	      : constant_addition.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-10-24
-- Last update: 2022-11-03
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du bloc addition de constante Pc
-- Entrées: state_i, counter_i
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

entity constant_addition is
	
	port(
		state_i : in type_state; -- état sur 320 bits
		counter_i : in bit4;
		state_o : out type_state);
		
end constant_addition;

architecture constant_addition_arch of constant_addition is
	signal constant_s : bit8;
																												
	begin 
	
		-- L'addition de constante n'affectant que x2; l'entrée et la sortie de x0, x1, x3 et x4 sont les mêmes
		state_o(0) <= state_i(0);
		state_o(1) <= state_i(1);
		state_o(3) <= state_i(3);
		state_o(4) <= state_i(4);
		
		-- Les 56 derniers bits de la sortie de x2 sont les 56 derniers bits de l'entrée de x2 
		state_o(2)(63 downto 8) <= state_i(2)(63 downto 8);
		
		-- Conversion des bits en entier
		constant_s <= round_constant(to_integer(unsigned(counter_i)));
		
		-- L'ajout de la constante se fait sur l'octet de poids faible de x2 avec un XOR
		state_o(2)(7 downto 0) <= state_i(2)(7 downto 0) xor constant_s;
		
end constant_addition_arch;
