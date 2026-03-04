with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;



procedure Lab1 is
   count: Positive;
   type Bool_Array is array (Positive range <>) of Boolean;
   pragma Atomic_Components(Bool_Array);
   can_stop: Bool_Array(1 .. 100) := (others => False);
   task type Progression(number: Integer;step: Integer);
   task type Controller(n: Positive);
   task body Progression is
      result: Long_Long_Integer := 0;
   begin
       Put_Line("Progression started:" & Integer'Image(number));
      loop
         result:=result+Long_Long_Integer(step);
         exit when can_stop(number);
         delay 0.001;
      end loop;
      Put_Line("Thread with number" & Integer'Image(number) & "has executed with result" & Long_Long_Integer'Image(result) & "step was" & Integer'Image(step));
   end Progression;
   task body Controller is
   begin
      for i in 1..n loop
         --delay Duration(i);
         delay 3.0;
         Put_Line("Stopping task" & Integer'Image(i));
      can_stop(i):=True;
      end loop;

   end Controller;
   type Progression_Access is access Progression;
   type Controller_Access is access Controller;
   type Progression_Array is array (Positive range <>) of Progression_Access;

   Tasks : Progression_Array(1 .. 100);

   c : Controller_Access;

   --p: Progression_Access;
begin
   declare
      str:String:=Get_Line;
      begin
   count:=Integer'Value(str);
   Skip_Line;

   for i in 1..count loop
      Tasks(i):= new Progression(i,i*2);
      end loop;
      c:= new Controller(count);
      end;

end Lab1;
