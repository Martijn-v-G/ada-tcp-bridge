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
      return Result;
   end To_Pong;

   function To_Ping (Msg : Messages.Message_Pong.Message)
     return Messages.Message_Ping.Message is
      Result : Messages.Message_Ping.Message;
   begin
      Result.Payload := Reverse_String (Msg.Payload);
      return Result;
   end To_Ping;

end Converter.Msg_Converter;