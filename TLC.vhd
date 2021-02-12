----------------------------------------------------------------------------------
-- Company: Marmara University
-- Engineer: Cüneyt Kepildek
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
--Bir anayol ile yan yol arasýndaki birleþimdeki trafik ýþýðý kontrol sistemi
--Yan yol üzerinde araba olup olmadýðýna dair bie sensör konumlanmýþtýr, 
--eðer araç var ise burdaki ýþýklarýda yeþil olarak deðiþtirmekte aksi takdirde bu ýþýðý
--sürekli kýrmýzýda tutmaktadýr.

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
-- IDLE : Bütün ışıklar kırmızı
-- s1 : T1 ve T3 sarı, diğerleri kırmızı
-- s2 : T1 ve T3 yeşil, diğerleri kırmızı
-- s3 : T1 ve T3 sarı, diğerleri kırmızı
-- s4 : T2 ve T4 yeşil, diğerleri kırmızı
-- s5 : T5 ve T7 sarı, diğerleri kımızı
-- s6 : T5 ve T7 yeşil, diğerleri kırmızı
-- s7 : T5 ve T7 sarı, diğerleri kırmızı
-- s8 : T6 ve T8 yeşil, diğerleri kırmızı
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
  GREEN_LIGHT_ENABLE <= '0'; --Pasif : yeþil ýþýk bekleme sayacý
  YELLOW_LIGHT_ENABLE <= '0';-- Pasif : sarý ýþýk bekleme sayacý
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
  GREEN_LIGHT_ENABLE <= '0'; --Pasif : yeþil ýþýk bekleme sayacý
  YELLOW_LIGHT_ENABLE <= '1';-- Aktif : sarý ýþýk bekleme sayacý 
  T1 <= "010"; --sarý
  T2 <= "10";
  T3 <= "010"; --sarý
  T4 <= "10";
  T5 <= "100";
  T6 <= "10";
  T7 <= "100";
  T8 <= "10";
  if(delay_2s_H='1') then --Sarý ýþýk 3 sn bekletir sonraki aþamaya geçer.
    next_state <= s2;
  else
    next_state <= s1;
  end if;

when s2 =>
  GREEN_LIGHT_ENABLE <= '1';--Aktif : yeþil ýþýk bekleme sayacý
  --RED_LIGHT_ENABLE <= '0';-- Pasif : kýrýmýzý ýþýk bekleme sayacý
  YELLOW_LIGHT_ENABLE <= '0';-- Pasif : sarý ýþýk bekleme sayacý
  --YELLOW_LIGHT2_ENABLE <= '0';-- Pasif : sarý ýþýk bekleme sayacý   
  T1 <= "001"; -- yeþil
  T2 <= "10";
  T3 <= "001"; -- yeþil
  T4 <= "10";
  T5 <= "100";
  T6 <= "10";
  T7 <= "100";
  T8 <= "10";
  if(delay_6s='1') then --Yeþil ýþýk 6 sn bekletir sonraki aþamaya geçer.
    next_state <= s3;
  else
    next_state <= s2;
  end if;
  
  when s3 =>
  GREEN_LIGHT_ENABLE <= '0';--Pasif : yeþil ýþýk bekleme sayacý
  --RED_LIGHT_ENABLE <= '0';-- Pasif : kýrýmýzý ýþýk bekleme sayacý
  YELLOW_LIGHT_ENABLE <= '1';-- Aktif : sarý ýþýk bekleme sayacý
  --YELLOW_LIGHT2_ENABLE <= '1';  
  T1 <= "010"; -- sarý
  T2 <= "10";
  T3 <= "010"; -- sarý
  T4 <= "10";
  T5 <= "100";
  T6 <= "10";
  T7 <= "100";
  T8 <= "10";
  if(delay_2s_H='1') then --Sarý ýþýk 2 sn bekletir sonraki aþamaya geçer.
    next_state <= s4;
  else
    next_state <= s3;
  end if;
  
  when s4 =>
  GREEN_LIGHT_ENABLE <= '1';--Aktif : yeþil ýþýk bekleme sayacý
  --RED_LIGHT_ENABLE <= '0';-- Pasif : kýrýmýzý ýþýk bekleme sayacý
  YELLOW_LIGHT_ENABLE <= '0';-- Pasif : sarý ýþýk bekleme sayacý  
  --YELLOW_LIGHT2_ENABLE <= '0';-- Pasif : sarý ýþýk bekleme sayacý 
  T1 <= "100"; 
  T2 <= "01"; --yeþil 
  T3 <= "100"; 
  T4 <= "01"; --yeþil
  T5 <= "100";
  T6 <= "10";
  T7 <= "100";
  T8 <= "10";
  if(delay_6s='1') then --Yeþil ýþýk 6 sn bekletir sonraki aþamaya geçer.
    next_state <= s5;
  else
    next_state <= s4;
  end if;
  
  when s5 =>
  GREEN_LIGHT_ENABLE <= '0';--Pasif : yeþil ýþýk bekleme sayacý
  --RED_LIGHT_ENABLE <= '0';-- Pasif : kýrýmýzý ýþýk bekleme sayacý
  YELLOW_LIGHT_ENABLE <= '1';-- Aktif : sarý ýþýk bekleme sayacý  
  T1 <= "100"; 
  T2 <= "10";
  T3 <= "100"; 
  T4 <= "10"; 
  T5 <= "010";--sarý
  T6 <= "10";
  T7 <= "010";--sarý
  T8 <= "10";
  if(delay_2s_H='1') then --Sarý ýþýk 2 sn bekletir sonraki aþamaya geçer.
    next_state <= s6;
  else
    next_state <= s5;
  end if;
  
  when s6 =>
  GREEN_LIGHT_ENABLE <= '1';--Aktif : yeþil ýþýk bekleme sayacý
  --RED_LIGHT_ENABLE <= '0';-- Pasif : kýrýmýzý ýþýk bekleme sayacý
  YELLOW_LIGHT_ENABLE <= '0';-- Pasif : sarý ýþýk bekleme sayacý  
  T1 <= "100"; 
  T2 <= "10"; 
  T3 <= "100"; 
  T4 <= "10";
  T5 <= "001";--Yeþil
  T6 <= "10";
  T7 <= "001";--Yeþil
  T8 <= "10";
  if(delay_6s='1') then --Yeþil ýþýk 6 sn bekletir sonraki aþamaya geçer.
    next_state <= s7;
  else
    next_state <= s6;
  end if;
  
  when s7 =>
  GREEN_LIGHT_ENABLE <= '0';--Pasif : yeþil ýþýk bekleme sayacý
  --RED_LIGHT_ENABLE <= '0';-- Pasif : kýrýmýzý ýþýk bekleme sayacý
  YELLOW_LIGHT_ENABLE <= '1';-- Aktif : sarý ýþýk bekleme sayacý  
  T1 <= "100"; 
  T2 <= "10";
  T3 <= "100"; 
  T4 <= "10"; 
  T5 <= "010";--sarý
  T6 <= "10";
  T7 <= "010";--sarý
  T8 <= "10";
  if(delay_2s_H='1') then --Sarý ýþýk 2 sn bekletir sonraki aþamaya geçer.
    next_state <= s8;
  else
    next_state <= s7;
  end if;
  
  when s8 =>
  GREEN_LIGHT_ENABLE <= '1';--Aktif : yeþil ýþýk bekleme sayacý
  --RED_LIGHT_ENABLE <= '0';-- Pasif : kýrýmýzý ýþýk bekleme sayacý
  YELLOW_LIGHT_ENABLE <= '0';-- Pasif : sarý ýþýk bekleme sayacý  
  T1 <= "100"; 
  T2 <= "10"; 
  T3 <= "100"; 
  T4 <= "10";
  T5 <= "100";
  T6 <= "01";--Yeþil
  T7 <= "100";
  T8 <= "01";--Yeþil
  if(delay_6s='1') then --Yeþil ýþýk 6 sn bekletir sonraki aþamaya geçer.
    next_state <= s1;
  else
    next_state <= s8;
  end if;
  when others => next_state <= s1;
  end case;
  end process;
  --Bu kýsýmda yeþil ve sarý ýþýklar için bekleme sürelerini saydýk
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
--Clock Divider
process(clk)
begin
if(rising_edge(clk)) then 
 counter_1s <= counter_1s + x"0000001";
 if(counter_1s >= x"0000003") then 
 -- change to x"2FAF080" for 50 MHz clock running real FPGA 
  counter_1s <= x"0000000";
 end if;
end if;
end process;
clk_1s_enable <= '1' when counter_1s = x"0000003" else '0'; -- x"0002" is for simulation
-- x"2FAF080" for 50Mhz clock on FPGA

end Behavioral;
