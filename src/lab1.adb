with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Containers.Generic_Array_Sort;



procedure Lab1 is
   count: Positive;
   type Bool_Array is array (Positive range <>) of Boolean;
   type Delay_Array is array (Positive range <>) of Float;
   pragma Atomic_Components(Bool_Array);
   can_stop: Bool_Array(1 .. 100) := (others => False);
   delays: Delay_Array(1..5) :=(2.0,5.0,8.0,10.0,12.0);

   subtype Random_Range is Integer range 1 .. 5;
   package Random_Int is new Ada.Numerics.Discrete_Random (Random_Range);
   use Random_Int;

   G : Generator;
   Num : Random_Range;

   type Tuple is record
      Item1   : Integer;
      Item2 : Float;
   end record;
   function "<" (L, R : Tuple) return Boolean is
   begin
      return L.Item2 < R.Item2;
   end "<";

   type Tuple_Array is array (Positive range <>) of Tuple;
   tuples: Tuple_Array(1 .. 100);
   procedure Sort is new Ada.Containers.Generic_Array_Sort
     (Positive, Tuple, Tuple_Array);

   task type Progression(number: Integer;step: Integer);
   task type Controller(n: Positive);
   task body Progression is
      result: Long_Long_Integer := 0;
      count_additions: Long_Long_Integer := 0;
   begin
       Put_Line("Progression started:" & Integer'Image(number));
      loop
         result:=result+Long_Long_Integer(step);
         count_additions:=count_additions+1;
         exit when can_stop(number);
         --delay 0.001;
      end loop;
      Put_Line("Thread with number" & Integer'Image(number) & "has executed with result" & Long_Long_Integer'Image(result) & "step was" & Integer'Image(step) & "count of additions" & Long_Long_Integer'Image(count_additions));
   end Progression;
   task body Controller is
   begin
      Reset(G);
      for i in 1..n loop
         tuples(i) :=(i,delays(Random(G)));
      end loop;
      Sort(tuples(1..n));
      delay(Duration(tuples(1).Item2));
      can_stop(tuples(1).Item1):=True;
      for i in 2..n loop
         --delay Duration(i);
         delay Duration(tuples(i).Item2-tuples(i-1).Item2);
         can_stop(tuples(i).Item1):=True;
         Put_Line("Stopping task" & Integer'Image(i));
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
