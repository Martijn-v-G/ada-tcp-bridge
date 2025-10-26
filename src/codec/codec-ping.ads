with Ada.Streams;  use Ada.Streams;
with Messages.Message_Ping;
with Messages.Message_Pong;

package Codec.Ping is

   function Encode (Msg : Messages.Message_Ping.Message)
     return Stream_Element_Array;

   function Decode (Data : Stream_Element_Array)
     return Messages.Message_Ping.Message;

end Codec.Ping;
