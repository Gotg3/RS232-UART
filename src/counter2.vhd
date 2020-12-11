library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;       -- for the signed, unsigned types and arithmetic ops

entity counter2 is  --contatore a 3 bit
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			ttr: out std_logic
			);
end counter2;

architecture behavioural2 of counter2 is

constant one: std_logic_vector(2 downto 0):= "001"; -- Bisogna avere lo stesso n di bit
--constant to add one
--constant N: std_logic_vector(11 downto 0):="101000101011"; --2603 to binar
signal count_sig: std_logic_vector(2 downto 0); --
signal end_cnt: std_logic;


begin
	counter_process: process(clk)
	begin
			if(clk' event and clk= '1') then
				if(rst ='1') then
					count_sig <= "000";
					end_cnt <='0';
				else 
						if(en = '1') then -- se enable Ã¨ attivo allora conta
							--if( count_sig = "111") then  
							if(end_cnt='1') then
								end_cnt <='0';
								count_sig <="000"; --azzeramento del contatore

							--count_sig <= count_sig + one;
							--faccio un casting in unsigned
							else 
								
								count_sig <= std_logic_vector(unsigned(count_sig)+ unsigned(one));
								
								
								end_cnt<=(count_sig(2) and count_sig(1) and (not count_sig(0))); --Il segnale count_sig si aggiorna effettivamente
								-- al colpo di clock successivo, spostando la condizione di end sopra o sotto non cambia in quanto lui va a testare 
								-- la condizione passata e non quella aggiornata. Per questo lui considera che quando mette 7 count_sig sia ancora
								-- 6 e l'aggiornamento verrà effettivamente sentito al colpo di clock dopo. Non si deve modificare tutto, quello che 
								-- ho scritto funziona perchè anche se il controllo sul numero viene fatto sotto l'incremento lui ancora quell'incremento
								-- non lo vede. Cioè se passo da 299 a 300 e ho bisogno del tc sul 300, io avrei scritto count<=count+1 e poi la condizione
								-- su 299 se guardi il timing non torna, ma lui è come se vedesse ancora 299.
								--if(count_sig = "110") then
									--end_cnt<='1';
								--end if;
																
							end if;
						else
							count_sig<=count_sig;
						--non devo comprire anche l'else perchÃ¨ il processo Ã¨ sensibile solo al clock
						
						end if;
					--faccio somma tra unsigned
				end if;
			end if;
	end process counter_process;
		ttr<=end_cnt;
		
end behavioural2;