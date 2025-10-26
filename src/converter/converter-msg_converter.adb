with Messages.Message_Types;
with Ada.Text_IO; use Ada.Text_IO;

package body Converter.Msg_Converter is

   function Reverse_String (S : String) return String is
      R : String (S'Range);
   begin
      for I in S'Range loop
         R (R'Last - (I - S'First)) := S (I);
      end loop;
      return R;
   end Reverse_String;

   function To_Pong (Msg : Messages.Message_Ping.Message)
     return Messages.Message_Pong.Message is
      Result : Messages.Message_Pong.Message;
   begin
      Result.Payload := Reverse_String (Msg.Payload);
      Result.Hdr.Msg_Type := Messages.Message_Types.Message_Type_Pong;
      Put_Line ("[Msg_Converter::To_Pong] IN [Type=" & Integer'Image (Integer (Msg.Hdr.Msg_Type))&
       " Payload=" &Msg.Payload & "]  ==> OUT [Type=" & Integer'Image (Integer (Result.Hdr.Msg_Type)) &
                      " Payload=" & Result.Payload & "]");
      return Result;
   end To_Pong;

   function To_Ping (Msg : Messages.Message_Pong.Message)
     return Messages.Message_Ping.Message is
      Result : Messages.Message_Ping.Message;
   begin
      Result.Payload := Reverse_String (Msg.Payload);
      Result.Hdr.Msg_Type := Messages.Message_Types.Message_Type_Ping;
      Put_Line ("[Msg_Converter::To_Ping] IN [Type=" & Integer'Image (Integer (Msg.Hdr.Msg_Type))&
       " Payload=" &Msg.Payload & "]  ==> OUT [Type=" & Integer'Image (Integer (Result.Hdr.Msg_Type)) &
                      " Payload=" & Result.Payload & "]");
      return Result;
   end To_Ping;

end Converter.Msg_Converter;