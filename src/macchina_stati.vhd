library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--simulata

entity macchina_stati is
port(reset,clk_25, TC_cnt,TTR_cnt,d_val: in std_logic;--clock a 25 MHz
     R_cnt1, R_cnt2, R_reg, CE1, LE, TxRDY,CE2, SE:  out std_logic; 
	  Sel: out std_logic_vector (1 downto 0));
end macchina_stati;

architecture Behavior of macchina_stati is

type State_type is (rst, Idle, Idle_end, start, start_end,dato, dato_cuscinetto,dato_end, dato_end_cuscinetto,stop, stop_end);-- dato1 è il dato iniziale, dato2 è il dato cambiato dopo lo shift enable e il counter enable 2
signal stato: State_type:=rst; --dato che usiamo la macchina a stati a due processi non serve mettere stato presente e stato futuro, ma basta uno stato
signal d_valid, TC, TTR: std_logic;
signal CE2_sig:std_logic:='0';
begin

R: process (clk_25) -- mettiamo solo il clock, perchè il reset è sincrono col clk, quindi nella sensitivity list mettiamo solo il clk
begin 
                   --il processo sincrono R rappresenta il registro di stato che sul fronte di clock aggiorna lo stato attuale y_Q allo stato futuro y_D
     if(clk_25'event and clk_25='1') then  
	  case stato is --stato attuale
		when rst=>
	      stato<=Idle;
	 
		when Idle=>
			if reset='1' then
				stato<=rst;
			elsif d_valid='0' then
				stato<=Idle;
		   else
			   stato<=Idle_end;
			end if;
			
		when Idle_end=>
			if reset='1' then
				stato<=rst;
			else
		    stato<=start;
			end if;
			
		when start=>
			if reset='1' then
				stato<=rst;
			elsif TC='0' then
				stato<=start;
		   else
			   stato<=start_end;
			end if;
		
      when start_end=>
			if reset='1' then
				stato<=rst;
			else
			   stato<=dato;
		   end if;
         		
		when dato=>
			if reset='1' then
				stato<=rst;
			elsif TC='0' then
				stato<=dato;
		   elsif (TC='1' and TTR='0') then
			   stato<=dato_cuscinetto;
			elsif (TC='1' and TTR='1') then
			   stato<=dato_end; -- prima era dato end_cuscinetto
			end if;
	   
		when dato_cuscinetto=>
			if reset='1' then
				stato<=rst;
			else
			   stato<=dato;
	--		elsif (TC='0' and TTR='0') then
	--			stato<=dato;
	--		elsif (TC='0' and TTR='1') then
	--		   stato<=dato;
	--		elsif (TC='1' and TTR='0') then
	--		   stato<=dato;
	--		elsif (TC='1' and TTR='1') then
	--			stato<=dato_end;
			end if;
			
		--when dato_end=>  
			--if reset='1' then
			--	stato<=rst;
			--elsif (TTR='1' and TC='1')  then
				--stato<=dato_end_cuscinetto;
		 --  else
			--   stato<=dato_end;
			--end if;
			
		when dato_end=> --when dato end cuscinetto
			if reset='1' then
				stato<=rst;
			elsif( CE2_sig='1' and TTR='1') then
	         stato<=stop;
			end if;
			
		when stop=>
			if reset='1' then
				stato<=rst;
			elsif TC='0' then
				stato<=stop;
		   else
			   stato<=stop_end;
			end if;
			
	   when stop_end=>
			if reset='1' then
				stato<=rst;
			else
			   stato<=Idle;
			end if;
				  
		when others =>
	         stato<=rst;
			end case;
	  end if;		  
end process R;

L: process (stato)-- il processo L determina le uscite a partire dagli stati attuali
begin 
   case stato is 
	     when rst=>
				R_cnt1<='1';
				R_cnt2<='1';
				R_reg<='1';
				SE<='0';
				LE<='0';
				Sel<="00";
				CE1<='0';
				CE2_sig<='0';
				TxRDY<='0';
		  when Idle=>
				R_cnt1<='0';
				R_cnt2<='0';
				R_reg<='0';
				SE<='0';
				LE<='0';
				Sel<="00";
				CE1<='0';
				CE2_sig<='0';
				TxRDY<='1';
		  when Idle_end=>
				R_cnt1<='0';
				R_cnt2<='0';
				R_reg<='0';
				SE<='0';
				LE<='1';
				Sel<="00";
				CE1<='0';
				CE2_sig<='0';
				TxRDY<='1';
		  when start=>
				R_cnt1<='0';
				R_cnt2<='0';
				R_reg<='0';
				SE<='0';
				LE<='0';
				Sel<="01";
				CE1<='1';
				CE2_sig<='0';
				TxRDY<='0';
		  when start_end=>
				R_cnt1<='0';
				R_cnt2<='0';
				R_reg<='0';
				SE<='0';
				LE<='0';
				Sel<="01";
				CE1<='1';
				CE2_sig<='0';
				TxRDY<='0';
		  when dato=>
				R_cnt1<='0';
				R_cnt2<='0';
				R_reg<='0';
				SE<='0';
				LE<='0';
				Sel<="10";
				CE1<='1';
				CE2_sig<='0';
				TxRDY<='0';
		  when dato_cuscinetto=>
				R_cnt1<='0';
				R_cnt2<='0';
				R_reg<='0';
				SE<='1';
				LE<='0';
				Sel<="10";
				CE1<='0';
				CE2_sig<='1';
				TxRDY<='0';
			--when dato_end=>   --questo a quanto pare non viene usato
			--	R_cnt1<='0';
				--R_cnt2<='0';
				--R_reg<='0';
				--SE<='0';
				--LE<='0';
				--Sel<="10";
				--CE1<='1';
				--CE2_sig<='0';
				--TxRDY<='0';
			when dato_end=>
				R_cnt1<='0';
				R_cnt2<='0';
				R_reg<='0';
				SE<='0';
				LE<='0';
				Sel<="10";
				CE1<='0';
				CE2_sig<='1';
				TxRDY<='0';
			when stop=>
				R_cnt1<='0';
				R_cnt2<='0';
				R_reg<='0';
				SE<='0';
				LE<='0';
				Sel<="11";
				CE1<='1';
				CE2_sig<='0';
				TxRDY<='0';
			when stop_end=>
				R_cnt1<='0';
				R_cnt2<='0';
				R_reg<='0';
				SE<='0';
				LE<='0';
				Sel<="00"; --rimesso il mux su idle
				CE1<='0';
				CE2_sig<='0';
				TxRDY<='0';

			when others => --� il reset
				R_cnt1<='1';
				R_cnt2<='1';
				R_reg<='1';
				SE<='0';
				LE<='0';
				Sel<="00";
				CE1<='0';
				CE2_sig<='0';
				TxRDY<='0';
			end case;
end process;
CE2<=CE2_sig;
d_valid<=d_val;
TC<=TC_cnt;
TTR<=TTR_cnt;
end Behavior;

