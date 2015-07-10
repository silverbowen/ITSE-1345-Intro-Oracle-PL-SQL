/* William Bowen
   ITSE 1345
   Competency 4.3 */

set serveroutput on;
 
/* Assignment 10-1 */

-- Here I'm logged on as System

-- Step 2) register trigger
begin 
 dbms_alert.register('reorder');
end;
/

-- Step 3) begin wait for alert
declare
 lv_msg_txt varchar2(40);
 lv_status_num number(1);
 
 begin
  dbms_alert.waitone('reorder', lv_msg_txt, lv_status_num, 120);
  dbms_output.put_line('Alert: ' || lv_msg_txt);
  dbms_output.put_line('Status: ' || lv_status_num);

end;
/
