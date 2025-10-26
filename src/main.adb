with Ada.Command_Line;
with Ada.Text_IO;
with Interfaces;
with Converter.Msg_Converter;
with Messages.Message_Ping;
with Messages.Message_Pong;
procedure Main is
   use Ada.Command_Line, Ada.Text_IO, Interfaces;

   function Payload4 (S : String) return String is
   begin
      if S'Length /= 4 then
         Put_Line ("Payload must be exactly 4 chars");
         Set_Exit_Status (1);
         raise Program_Error;
      end if;
      return S (S'First .. S'First + 3);
   end Payload4;

   MT   : Integer;
   P4   : String (1 .. 4);
begin
   if Argument_Count /= 2 then
      Put_Line ("Usage: main <type:1|2> <payload:4 chars>");
      Set_Exit_Status (1);
      return;
   end if;

   MT := Integer'Value (Argument (1));
   P4 := Payload4 (Argument (2));

   case MT is
      when 1 =>
         declare
            Inp : Messages.Message_Ping.Message :=
              (Hdr  => (Msg_Type => Unsigned_16 (1)),
               Payload => P4);
            Outp : constant Messages.Message_Pong.Message :=
              Converter.Msg_Converter.To_Pong (Inp);
         begin
            Put_Line ("RX=[Type=" & Integer'Image (Integer (Inp.Hdr.Msg_Type))& " Payload=" &Inp.Payload & " ==> TX=[Type=" & Integer'Image (Integer (Outp.Hdr.Msg_Type)) &
                      " Payload=" & Outp.Payload & "]");
         end;

      when 2 =>
         declare
            Inp : Messages.Message_Pong.Message :=
              (Hdr  => (Msg_Type => Unsigned_16 (2)),
               Payload => P4);
            Outp : constant Messages.Message_Ping.Message :=
              Converter.Msg_Converter.To_Ping (Inp);
         begin
            Put_Line ("RX=[Type=" & Integer'Image (Integer (Inp.Hdr.Msg_Type))& " Payload=" &Inp.Payload & " ==> TX=[Type=" & Integer'Image (Integer (Outp.Hdr.Msg_Type)) &
                      " Payload=" & Outp.Payload & "]");
         end;

      when others =>
         Put_Line ("Unsupported message type: " & Integer'Image (MT));
         Set_Exit_Status (1);
   end case;
end Main;
