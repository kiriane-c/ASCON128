-------------------------------------------------------------------------------
-- Title      : PACKAGE DEFINITION
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : ascon_pack.vhd
-- Author     : Jean-Baptiste RIGAUD  <rigaud@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-08-25
-- Last update: 2022-08-25
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du chiffrement leger ASCON
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-08-25  1.0	rigaud	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package ascon_pack is

  subtype bit4 is std_logic_vector(3 downto 0);
  subtype bit5 is std_logic_vector(4 downto 0);
  subtype bit8 is std_logic_vector(7 downto 0);
  subtype bit16 is std_logic_vector(15 downto 0);
  subtype bit32 is std_logic_vector(31 downto 0);
  subtype bit64 is std_logic_vector(63 downto 0);
  subtype bit128 is std_logic_vector(127 downto 0);

  type type_state is array (0 to 4) of bit64;  -- type de l'état intermédiaire de ASCON
  type type_constant is array (0 to 11) of bit8;  -- tableau de constante pour l'addition des constantes


  constant round_constant : type_constant := (x"F0", x"E1", x"D2", x"C3", x"B4", x"A5", x"96", x"87", x"78", x"69", x"5A", x"4B");

  constant IV_c : bit64 := x"80400C0600000000";	 -- vecteur d'iitialisation pour ASCON-128
  
  

end package ascon_pack;
