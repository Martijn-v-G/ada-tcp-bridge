with Messages.Message_Ping;
with Messages.Message_Pong;
use Messages.Message_Ping;
use Messages.Message_Pong;

package Converter.Msg_Converter is
   function To_Pong (Msg : Messages.Message_Ping.Message) return Messages.Message_Pong.Message;
   function To_Ping (Msg : Messages.Message_Pong.Message) return Messages.Message_Ping.Message;
end Converter.Msg_Converter;
