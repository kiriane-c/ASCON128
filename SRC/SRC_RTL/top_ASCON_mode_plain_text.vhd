-----------------------------------------------------------------------------------
-- File	      : top_ASCON_mode_plain_text.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-07
-- Last update: 2022-12-07
-- Standard   : VHDL'93/02
-----------------------------------------------------------------------------------
-- Description:	 conception de la troisième phase de ASCON
-- Entrées: resetb_i, clock_i, start_i, key_i, nonce_i, data_i, IV_i, data_valid_i
-- Sorties: end_o, cipher_o, cipher_valid_o
-----------------------------------------------------------------------------------
-- Copyright (c) 2022 
-----------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-10-24  1.0	nguego	Created
-----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use lib_rtl.ascon_pack.all;

entity top_ASCON_mode_plain_text is
  port (
    clock_i	 : in std_logic;
    resetb_i : in std_logic;
    start_i	: in std_logic;
    data_valid_i : in std_logic;
    data_i : in bit64;
    key_i : in bit128;	-- la clé K
    nonce_i : in bit128; -- le nonce N; nombre arbitraire
    IV_i : in bit64;	-- le vecteur d'initialisation IV
    
    end_o : out std_logic;
    cipher_valid_o : out std_logic;
    cipher_o : out bit64);
    
end entity top_ASCON_mode_plain_text;

architecture top_ASCON_mode_plain_text_arch of top_ASCON_mode_plain_text is
-- top_ASCON_mode_plain_text est l'entité de la phase de traitement de text clair de ASCON géré par la machine d'état fsm_mode_plain_text
-- utilise les composants ainsi définis ; la permutation finale, la machine d'état, le compteur_double_init

	component permutation_step2 port(
		data_sel_i : in std_logic;
		resetb_i : in std_logic;
		clock_i : in std_logic;
		en_xor_begin_i : in std_logic;	-- enable key de xor_begin
		en_key_xor_end_i : in std_logic;	-- enable key de xor_end
		en_bypass_i : in std_logic;	-- bypass de xor_end
		en_reg_state_i : in std_logic;
		round_i : in bit4;
		key_i : in bit128;
		data_i : in bit64;
		state_i : in type_state;
		cipher_o : out bit64;
		state_o : out type_state);
	end component;
	
	component fsm_moore_mode_plain_text is port(
	    clock_i	 : in std_logic;
	    resetb_i	 : in std_logic;
	    start_i	 : in std_logic;
	    round_i : in bit4;
	    data_valid_i : in std_logic;
	    data_sel_o : out std_logic;
	    end_o	: out std_logic;
	    en_cpt_o : out std_logic;
	    init_0_o : out std_logic;
	    init_6_o : out std_logic;
	    cipher_valid_o : out std_logic;
	    en_xor_begin_o : out std_logic;
	    en_reg_state_o : out std_logic;
	    en_bypass_o : out std_logic;
	    en_key_xor_end_o : out std_logic);
  end component;
   
  component compteur_double_init is port(
    clock_i  : in  std_logic;
    resetb_i : in  std_logic;
    enable_i : in  std_logic;
    init_0_i : in  std_logic;
    init_6_i : in  std_logic;
    compteur_o : out bit4);
  end component;
  
  signal init_0_s, init_6_s, en_xor_begin_s, en_bypass_s, en_key_xor_end_s, en_reg_state_s : std_logic;
  signal data_sel_s, en_cpt_s, end_s, cipher_valid_s : std_logic;
  signal round_s : bit4;
  signal cipher_s : bit64;
  signal state_i_s, state_o_s : type_state;
  
begin

	-- state_i <= IV_i & key_i & nonce_i
	state_i_s(0) <= IV_i;
	state_i_s(1) <= key_i(127 downto 64);
	state_i_s(2) <= key_i(63 downto 0);
	state_i_s(3) <= nonce_i(127 downto 64);
	state_i_s(4) <= nonce_i(63 downto 0);
	
	fsm : fsm_moore_mode_plain_text port map(
		clock_i	=> clock_i,
    resetb_i => resetb_i,
    start_i	=> start_i,
    round_i	=> round_s,
    data_valid_i => data_valid_i,

    data_sel_o => data_sel_s,
    end_o	=> end_s,
    en_cpt_o => en_cpt_s,
    init_0_o => init_0_s,
    init_6_o => init_6_s,
    en_xor_begin_o => en_xor_begin_s,
    cipher_valid_o => cipher_valid_s,
    en_bypass_o => en_bypass_s,
    en_reg_state_o => en_reg_state_s,
    en_key_xor_end_o => en_key_xor_end_s);
    
  compteur : compteur_double_init port map(
  	clock_i => clock_i,
  	resetb_i => resetb_i,
  	enable_i => en_cpt_s,
  	init_0_i => init_0_s,
  	init_6_i => init_6_s,
  	compteur_o => round_s);
	
	pem2 : permutation_step2 port map(
  	data_sel_i => data_sel_s,
		resetb_i => resetb_i,
		clock_i => clock_i,
		en_xor_begin_i => en_xor_begin_s,	--enable key de xor_end
		en_key_xor_end_i => en_key_xor_end_s,	--enable key de xor_begin
		en_bypass_i => en_bypass_s,
		en_reg_state_i => en_reg_state_s,
		round_i => round_s,
		key_i => key_i,
		data_i => data_i,
		state_i => state_i_s,
		cipher_o => cipher_s,
		state_o => state_o_s);
	
	cipher_valid_o <= cipher_valid_s;
	cipher_o <= cipher_s when cipher_valid_s = '1';
	end_o <= end_s;
  	
end architecture top_ASCON_mode_plain_text_arch;

library LIB_RTL;
configuration top_ASCON_mode_plain_text_conf of top_ASCON_mode_plain_text is
	for top_ASCON_mode_plain_text_arch
			for all : fsm_moore_mode_plain_text
				use entity LIB_RTL.fsm_moore_mode_plain_text(fsm_moore_mode_plain_text_arch);
			end for;
			for all : compteur_double_init
				use entity LIB_RTL.compteur_double_init(compteur_double_init_arch);
			end for;
			for all : permutation_step2
				use configuration LIB_RTL.permutation_step2_conf;
			end for;
	end for;
end top_ASCON_mode_plain_text_conf;
