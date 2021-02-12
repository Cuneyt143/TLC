----------------------------------------------------------------------------------
-- Company: Marmara University
-- Engineer: C�neyt KEP�LDEK
-- 
-- Create Date: 19.01.2021 18:12:00
-- Design Name: 
-- Module Name: TLC - Behavioral
-- Project Name: Traffic Light Controller
-- Target Devices: Artix-7 g234 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--Bir anayol ile yan yol aras�ndaki birle�imdeki trafik ����� kontrol sistemi
--Yan yol �zerinde araba olup olmad���na dair bie sens�r konumlanm��t�r, 
--e�er ara� var ise burdaki ���klar�da ye�il olarak de�i�tirmekte aksi takdirde bu �����
--s�rekli k�rm�z�da tutmaktad�r.

entity TLC is
  Port ( sensor : in std_logic;
         clk : in std_logic;
         rst_n : in std_logic;
         T1, T3, T5, T7 : out std_logic_vector(2 downto 0);
         T2, T4, T6, T8 : out std_logic_vector(1 downto 0)
          );
end TLC;

architecture Behavioral of TLC is
signal counter_1s: std_logic_vector(27 downto 0):= x"0000000";
signal delay_count: std_logic_vector(3 downto 0):= x"0";
signal delay_6s, delay_2s_H, YELLOW_LIGHT_ENABLE, GREEN_LIGHT_ENABLE: std_logic:='0';
signal clk_1s_enable: std_logic; -- 1s clock enable 
type FSM_States is (IDLE,s1,s2,s3,s4,s5, s6, s7, s8, s9);
-- IDLE : All lights red
-- s1 : T1 and T3 yellow, others red
-- s2 : T1 and T3 green, others red
-- s3 : T1 and T3 yellow, others red
-- s4 : T2 and T4 green, others red
-- s5 : T5 and T7 yellow, others red
-- s6 : T5 and T7 green, others red
-- s7 : T5 and T7 yellow, others red
-- s8 : T6 and T8 green, others red
signal current_state, next_state: FSM_States;

begin
process(clk,rst_n) 
begin
  if (rst_n='1') then
    current_state <= IDLE;
    --next_state <= s1;
  elsif(rising_edge(clk)) then 
    current_state <= next_state; 
end if; 
end process;

process(current_state,delay_2s_H,delay_6s)
begin
case current_state is
when IDLE => 
  GREEN_LIGHT_ENABLE <= '0'; --Pasif : ye�il ���k bekleme sayac�
  YELLOW_LIGHT_ENABLE <= '0';-- Pasif : sar� ���k bekleme sayac� 
  --YELLOW_LIGHT2_ENABLE <= '0';-- disable YELLOW light Farmway delay counting
  T1 <= "100"; -- Red lights on(all)
  T2 <= "10";
  T3 <= "100";
  T4 <= "10";
  T5 <= "100";
  T6 <= "10";
  T7 <= "100";
  T8 <= "10";  
  next_state <= s1;
when s1 =>  --
  GREEN_LIGHT_ENABLE <= '0'; --Pasif : ye�il ���k bekleme sayac�
  YELLOW_LIGHT_ENABLE <= '1';-- Aktif : sar� ���k bekleme sayac� 
  T1 <= "010"; --sar�
  T2 <= "10";
  T3 <= "010"; --sar�
  T4 <= "10";
  T5 <= "100";
  T6 <= "10";
  T7 <= "100";
  T8 <= "10";
  if(delay_2s_H='1') then --Sar� ���k 3 sn bekletir sonraki a�amaya ge�er.
    next_state <= s2;
  else
    next_state <= s1;
  end if;

when s2 =>
  GREEN_LIGHT_ENABLE <= '1';--Aktif : ye�il ���k bekleme sayac�
  --RED_LIGHT_ENABLE <= '0';-- Pasif : k�r�m�z� ���k bekleme sayac�
  YELLOW_LIGHT_ENABLE <= '0';-- Pasif : sar� ���k bekleme sayac�
  --YELLOW_LIGHT2_ENABLE <= '0';-- Pasif : sar� ���k bekleme sayac�   
  T1 <= "001"; -- ye�il
  T2 <= "10";
  T3 <= "001"; -- ye�il
  T4 <= "10";
  T5 <= "100";
  T6 <= "10";
  T7 <= "100";
  T8 <= "10";
  if(delay_6s='1') then --Ye�il ���k 6 sn bekletir sonraki a�amaya ge�er.
    next_state <= s3;
  else
    next_state <= s2;
  end if;
  
  when s3 =>
  GREEN_LIGHT_ENABLE <= '0';--Pasif : ye�il ���k bekleme sayac�
  --RED_LIGHT_ENABLE <= '0';-- Pasif : k�r�m�z� ���k bekleme sayac�
  YELLOW_LIGHT_ENABLE <= '1';-- Aktif : sar� ���k bekleme sayac�
  --YELLOW_LIGHT2_ENABLE <= '1';  
  T1 <= "010"; -- sar�
  T2 <= "10";
  T3 <= "010"; -- sar�
  T4 <= "10";
  T5 <= "100";
  T6 <= "10";
  T7 <= "100";
  T8 <= "10";
  if(delay_2s_H='1') then --Sar� ���k 2 sn bekletir sonraki a�amaya ge�er.
    next_state <= s4;
  else
    next_state <= s3;
  end if;
  
  when s4 =>
  GREEN_LIGHT_ENABLE <= '1';--Aktif : ye�il ���k bekleme sayac�
  --RED_LIGHT_ENABLE <= '0';-- Pasif : k�r�m�z� ���k bekleme sayac�
  YELLOW_LIGHT_ENABLE <= '0';-- Pasif : sar� ���k bekleme sayac�  
  --YELLOW_LIGHT2_ENABLE <= '0';-- Pasif : sar� ���k bekleme sayac� 
  T1 <= "100"; 
  T2 <= "01"; --ye�il 
  T3 <= "100"; 
  T4 <= "01"; --ye�il
  T5 <= "100";
  T6 <= "10";
  T7 <= "100";
  T8 <= "10";
  if(delay_6s='1') then --Ye�il ���k 6 sn bekletir sonraki a�amaya ge�er.
    next_state <= s5;
  else
    next_state <= s4;
  end if;
  
  when s5 =>
  GREEN_LIGHT_ENABLE <= '0';--Pasif : ye�il ���k bekleme sayac�
  --RED_LIGHT_ENABLE <= '0';-- Pasif : k�r�m�z� ���k bekleme sayac�
  YELLOW_LIGHT_ENABLE <= '1';-- Aktif : sar� ���k bekleme sayac�  
  T1 <= "100"; 
  T2 <= "10";
  T3 <= "100"; 
  T4 <= "10"; 
  T5 <= "010";--sar�
  T6 <= "10";
  T7 <= "010";--sar�
  T8 <= "10";
  if(delay_2s_H='1') then --Sar� ���k 2 sn bekletir sonraki a�amaya ge�er.
    next_state <= s6;
  else
    next_state <= s5;
  end if;
  
  when s6 =>
  GREEN_LIGHT_ENABLE <= '1';--Aktif : ye�il ���k bekleme sayac�
  --RED_LIGHT_ENABLE <= '0';-- Pasif : k�r�m�z� ���k bekleme sayac�
  YELLOW_LIGHT_ENABLE <= '0';-- Pasif : sar� ���k bekleme sayac�  
  T1 <= "100"; 
  T2 <= "10"; 
  T3 <= "100"; 
  T4 <= "10";
  T5 <= "001";--Ye�il
  T6 <= "10";
  T7 <= "001";--Ye�il
  T8 <= "10";
  if(delay_6s='1') then --Ye�il ���k 6 sn bekletir sonraki a�amaya ge�er.
    next_state <= s7;
  else
    next_state <= s6;
  end if;
  
  when s7 =>
  GREEN_LIGHT_ENABLE <= '0';--Pasif : ye�il ���k bekleme sayac�
  --RED_LIGHT_ENABLE <= '0';-- Pasif : k�r�m�z� ���k bekleme sayac�
  YELLOW_LIGHT_ENABLE <= '1';-- Aktif : sar� ���k bekleme sayac�  
  T1 <= "100"; 
  T2 <= "10";
  T3 <= "100"; 
  T4 <= "10"; 
  T5 <= "010";--sar�
  T6 <= "10";
  T7 <= "010";--sar�
  T8 <= "10";
  if(delay_2s_H='1') then --Sar� ���k 2 sn bekletir sonraki a�amaya ge�er.
    next_state <= s8;
  else
    next_state <= s7;
  end if;
  
  when s8 =>
  GREEN_LIGHT_ENABLE <= '1';--Aktif : ye�il ���k bekleme sayac�
  --RED_LIGHT_ENABLE <= '0';-- Pasif : k�r�m�z� ���k bekleme sayac�
  YELLOW_LIGHT_ENABLE <= '0';-- Pasif : sar� ���k bekleme sayac�  
  T1 <= "100"; 
  T2 <= "10"; 
  T3 <= "100"; 
  T4 <= "10";
  T5 <= "100";
  T6 <= "01";--Ye�il
  T7 <= "100";
  T8 <= "01";--Ye�il
  if(delay_6s='1') then --Ye�il ���k 6 sn bekletir sonraki a�amaya ge�er.
    next_state <= s1;
  else
    next_state <= s8;
  end if;
  when others => next_state <= s1;
  end case;
  end process;
  --Bu k�s�mda ye�il ve sar� ���klar i�in bekleme s�relerini sayd�k
process(clk)
begin
if(rising_edge(clk)) then 
if(clk_1s_enable='1') then
 if(GREEN_LIGHT_ENABLE='1' or YELLOW_LIGHT_ENABLE='1') then
  delay_count <= delay_count + x"1";
  if((delay_count = x"5") and GREEN_LIGHT_ENABLE ='1') then 
   delay_6s <= '1';
   delay_2s_H <= '0';
   delay_count <= x"0";
  elsif((delay_count = x"1") and YELLOW_LIGHT_ENABLE= '1') then
   delay_6s <= '0';
   delay_2s_H <= '1';
   delay_count <= x"0";
  else
   delay_6s <= '0';
   delay_2s_H <= '0';
  end if;
 end if;
 end if;
end if;
end process;

process(clk)
begin
if(rising_edge(clk)) then 
 counter_1s <= counter_1s + x"0000001";
 if(counter_1s >= x"0000003") then -- x"0004" is for simulation
 -- change to x"2FAF080" for 50 MHz clock running real FPGA 
  counter_1s <= x"0000000";
 end if;
end if;
end process;
clk_1s_enable <= '1' when counter_1s = x"0000003" else '0'; -- x"0002" is for simulation
-- x"2FAF080" for 50Mhz clock on FPGA

end Behavioral;
