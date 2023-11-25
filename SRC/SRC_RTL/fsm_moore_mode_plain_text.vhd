------------------------------------------------------------------------------------------------------------------------------------------
-- File	      : fsm_moore_mode_plain_text.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-07
-- Last update: 2022-12-22
-- Standard   : VHDL'93/02
------------------------------------------------------------------------------------------------------------------------------------------
-- Description:	 conception de la machine d'état pour l'injection de blocs de textes clairs
-- Entrées: clock_i, resetb_i, start_i, round_i, data_valid_i
-- Sorties: data_sel_o, end_o, en_cpt_o, init_0_o, init_6_o, en_xor_begin_o, cipher_valid_o, en_reg_state_o, en_bypass_o, en_key_xor_end_o
------------------------------------------------------------------------------------------------------------------------------------------
-- Copyright (c) 2022 
------------------------------------------------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-10-24  1.0	nguego	Created
------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use lib_rtl.ascon_pack.all;

entity fsm_moore_mode_plain_text is
  port(
    clock_i	 : in std_logic;
    resetb_i : in std_logic;
    start_i	 : in std_logic;
    data_valid_i : in std_logic;
    round_i	 : in bit4;

    data_sel_o : out std_logic;
    end_o	: out std_logic;	-- indique la fin du chiffrement
    en_cpt_o : out std_logic;	-- active compteur double
    init_0_o : out std_logic;	-- la constante de ronde commence à 0 (p12)
    init_6_o : out std_logic; -- la constante de ronde commence à 6 (p6)
    cipher_valid_o : out std_logic;	-- indique la présence du chiffré
    en_xor_begin_o : out std_logic;	-- active xor_begin
    en_reg_state_o : out std_logic;	
    en_bypass_o : out std_logic;	-- bypass xor_end
    en_key_xor_end_o : out std_logic);	-- active xor_end

end entity fsm_moore_mode_plain_text;

architecture fsm_moore_mode_plain_text_arch of fsm_moore_mode_plain_text is

  type fsm_state is (attente, conf_init, init_ronde0, initialisation, end_init, attente_da, da_ronde6, da, end_da, attente_b1_tx, b1_tx_ronde6, b1_tx, end_b1_tx,
attente_b2_tx, b2_tx_ronde6, b2_tx, end_b2_tx, attente_b3_tx, b3_tx_ronde6, b3_tx, end_b3_tx, fin);	-- tx : texte, -- bX : bloc X de 1 à 3
  signal etat_present : fsm_state;
  signal etat_futur : fsm_state;

-- Cette machine d'état reprend la machine d'état en mode_donnée_associée. Elle ajoute des états similaires pour le traitement des trois premiers blocs de 
-- texte clair
  
begin  -- architecture fsm_mode_plain_text_arch

  seq0 : process (clock_i, resetb_i) is
  begin	 -- process seq0
    if (resetb_i = '0') then		-- asynchronous reset (active low)
      etat_present <= attente;
      
    elsif (clock_i'event and clock_i = '1') then  -- rising clock edge
      etat_present <= etat_futur;
    end if;
  end process seq0;

	comb_0 : process (etat_present, start_i, round_i, data_valid_i) is
		begin	

		  case etat_present is
	      when attente => -- l'état est initialement en attente
	          if (start_i = '1') then -- quand start_i passe à 1, l'état futur est la configuration de l'initialisation
	              etat_futur <= conf_init;
	          else
	              etat_futur <= attente; -- sinon, on reste en attente
	          end if;
	          
	      when conf_init => 
		      etat_futur <= init_ronde0; -- on passe à initialisation de la ronde
		      
	      when init_ronde0 =>
		      etat_futur <= initialisation; -- on passe à l'initialisation propre
		      
	      when initialisation =>
	          if (round_i = x"A") then -- durant la permutation, si la constante de ronde vaut 10, on passe à la fin l'initialisation
	              etat_futur <= end_init;
	          else
	              etat_futur <= initialisation;
	          end if;
	          
	      when end_init =>
		      etat_futur <= attente_da;	-- on passe en mode attente de la donnée
		      
		    when attente_da =>
		    	if(data_valid_i = '1') then	-- activé par le signal data_valid_i
		    		etat_futur <= da_ronde6;
		    	else
		    		etat_futur <= attente_da;
		    	end if;
		    
		    when da_ronde6 =>
		    	etat_futur <= da;	-- xor begin actif
		    	
		    when da =>
		    	if (round_i = x"A") then	-- lorsque la ronde vaut 10, on passe en fin du traitement de la donnée associée
		    		etat_futur <= end_da;
		    	else
		    		etat_futur <= da;
		    	end if;
		    	
		    when end_da =>	-- active xor end
		    	etat_futur <= attente_b1_tx;
		    	
		    when attente_b1_tx =>	-- l'état est en attente du signal de validation de la présence d'un bloc de texte clair
		    	if(data_valid_i = '1') then
		    		etat_futur <= b1_tx_ronde6;
		    	else
		    		etat_futur <= attente_b1_tx;
		    	end if;
		    
		    when b1_tx_ronde6 =>	-- le chiffré C1 obtenu
		    	etat_futur <= b1_tx; --xor begin actif
		    	
		    when b1_tx =>
		    	if (round_i = x"A") then
		    		etat_futur <= end_b1_tx;
		    	else
		    		etat_futur <= b1_tx;
		    	end if;
		    	
		    when end_b1_tx =>
		    	etat_futur <= attente_b2_tx;

		when attente_b2_tx =>
	    	if(data_valid_i = '1') then
	    		etat_futur <= b2_tx_ronde6;
	    	else
	    		etat_futur <= attente_b2_tx;
	    	end if;
		    
		    when b2_tx_ronde6 =>	-- le chiffré C2 obtenu
		    	etat_futur <= b2_tx; --xor begin actif
		    	
		    when b2_tx =>
		    	if (round_i = x"A") then
		    		etat_futur <= end_b2_tx;
		    	else
		    		etat_futur <= b2_tx;
		    	end if;
		    	
		    when end_b2_tx =>
		    	etat_futur <= attente_b3_tx;

	when attente_b3_tx =>
	    	if(data_valid_i = '1') then
	    		etat_futur <= b3_tx_ronde6;
	    	else
	    		etat_futur <= attente_b3_tx;
	    	end if;
		    
		    when b3_tx_ronde6 =>	-- le chiffré C3 obtenu
		    	etat_futur <= b3_tx; --xor begin actif
		    	
		    when b3_tx =>
		    	if (round_i = x"A") then
		    		etat_futur <= end_b3_tx;
		    	else
		    		etat_futur <= b3_tx;
		    	end if;
		    	
		    when end_b3_tx =>
		    	etat_futur <= fin;
		    	
	      when fin =>
		      etat_futur <= attente;
	
	      when others =>
	      	etat_futur <= attente;
	      
		  end case;
		end process comb_0;

  comb_1 : process (etat_present) is
		begin	 -- process comb_1
		  
		  -- valeurs par défaut des stimulii de la FSM
		  data_sel_o <= '0';
		  end_o <= '0';
		  en_cpt_o <= '0';
		  init_0_o <= '0';
		  init_6_o <= '0';
		  en_xor_begin_o <= '0';
		  en_bypass_o  <= '1';
		  en_key_xor_end_o <= '0';
		  en_reg_state_o <= '0';
		  cipher_valid_o <= '0';

	case etat_present is
		  
		  when attente =>
	          
	      when conf_init =>
		  en_cpt_o <= '1';	-- on active le compteur de ronde
		  init_0_o <= '1';	-- on active le début de la ronde à 0
		  en_reg_state_o <= '1'; -- state sauvegardé

	      when init_ronde0 =>
		  en_cpt_o <= '1';
		  en_reg_state_o <= '1';

	      when initialisation =>
		en_cpt_o <= '1';
		data_sel_o <= '1';	-- le state en entrée n'est plus la valeur initiale mais ceux en sortie du registre
		en_reg_state_o <= '1';

	      when end_init =>
		  en_cpt_o <= '1';
		  data_sel_o <= '1';
		  
		  -- cas 2 du xor_end (en_bypass_i = '0' et en_key_i = '1'), la sortie est state xor "0...0"&K
		  en_bypass_o  <= '0';
		  en_key_xor_end_o <= '1';
		  en_reg_state_o <= '1';
		  
	      when attente_da =>
	      	en_cpt_o <= '1';
	      	init_6_o <= '1';	-- on active le début de la ronde à 6 (p6)
	      	
	      when da_ronde6 =>
	      	en_cpt_o <= '1';
	      	en_xor_begin_o <= '1';	-- xor_begin activé
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';	-- le state est toujours sauvegardé
	      	
	      when da =>
	      	en_cpt_o <= '1';
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';
	      	
	      when end_da =>
	      	en_cpt_o <= '1';
	      	data_sel_o <= '1';
	      	
	      	-- cas 4 du xor_end (en_bypass_i = '0' et en_key_i = '0'), la sortie est state xor "0...0"&1
	      	en_bypass_o <= '0';
	      	en_key_xor_end_o <= '0';
	      	en_reg_state_o <= '1';
	      	
	      when attente_b1_tx =>
	      	en_cpt_o <= '1';
	      	init_6_o <= '1';
	      	
	      when b1_tx_ronde6 =>
	      	en_cpt_o <= '1';
	      	en_xor_begin_o <= '1';	-- state_o <= state_i xor P1
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';
		cipher_valid_o <= '1';	-- C1 obtenu
	      	
	      when b1_tx =>
	      	en_cpt_o <= '1';
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';
	      	
	      when end_b1_tx =>
	      	en_cpt_o <= '1';
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';

	when attente_b2_tx =>
	      	en_cpt_o <= '1';
	      	init_6_o <= '1';
	      	
	      when b2_tx_ronde6 =>
	      	en_cpt_o <= '1';
	      	en_xor_begin_o <= '1';	-- state_o <= state_i xor P2
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';
		cipher_valid_o <= '1';	-- C2 obtenu
	      	
	      when b2_tx =>
	      	en_cpt_o <= '1';
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';
	      	
	      when end_b2_tx =>
	      	en_cpt_o <= '1';
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';

	      when attente_b3_tx =>
	      	en_cpt_o <= '1';
	      	init_6_o <= '1';
	      	
	      when b3_tx_ronde6 =>
	      	en_cpt_o <= '1';
	      	en_xor_begin_o <= '1';	-- state_o <= state_i xor P3
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';
		cipher_valid_o <= '1';	-- C3 obtenu
	      	
	      when b3_tx =>
	      	en_cpt_o <= '1';
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';
	      	
	      when end_b3_tx =>
	      	en_cpt_o <= '1';
	      	data_sel_o <= '1';
	      	en_reg_state_o <= '1';
	      	
	      when fin =>
		end_o <= '1';
		
	      when others =>

		  end case;
  end process comb_1;

end architecture fsm_moore_mode_plain_text_arch;
