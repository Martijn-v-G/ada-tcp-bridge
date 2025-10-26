with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Streams;
with GNAT.Sockets;
with Codec.Ping;
with Messages.Message_Ping;

use Ada.Text_IO;
use GNAT.Sockets;
use Ada.Streams;

procedure Bridge is
   Listener : Socket_Type;
   Client   : Socket_Type;
   Addr     : Sock_Addr_Type;
   Port     : Port_Type;

   Buffer : Stream_Element_Array (1 .. 1024);
   Used   : Stream_Element_Offset := 0;
   Last   : Stream_Element_Offset := 0;

   Timeout : constant Duration := 0.0;  -- seconds

   procedure Process_Message (Msg_Bytes : Stream_Element_Array) is
   begin
      if Msg_Bytes (1) = 1 then
         declare
            Msg : constant Messages.Message_Ping.Message :=
              Codec.Ping.Decode (Msg_Bytes);
         begin
            Put_Line ("Decoded Ping: " & Msg.Payload);
         end;
      else
         Put_Line ("Unknown message type: " &
                   Stream_Element'Image (Msg_Bytes (1)));
      end if;
   end Process_Message;

begin
   Initialize;

   if Ada.Command_Line.Argument_Count < 1 then
      Put_Line ("Usage: bridge <port>");
      return;
   end if;

   Port := Port_Type'Value (Ada.Command_Line.Argument (1));

   Create_Socket (Listener);
   Set_Socket_Option (Listener, Socket_Level, (Reuse_Address, True));
   Bind_Socket (Listener, (Family_Inet, Any_Inet_Addr, Port));
   Listen_Socket (Listener);

   Put_Line ("Listening on port " & Port'Image);

   loop
      Accept_Socket (Listener, Client, Addr);
      Put_Line ("Client connected from " &
                Image (Addr.Addr) & ":" & Port'Image);

      Used := 0;
 
      declare
         Done : Boolean := False;
      begin
         while not Done loop
            begin
               declare
                  Read_Last : Stream_Element_Offset;
               begin
                  -- Use timeout so it doesn’t hang forever
                  GNAT.Sockets.Set_Socket_Option
                    (Client, Socket_Level, (Receive_Timeout, Timeout));

                  Put_Line ("Receive socket..");
                  Receive_Socket
                    (Client,
                     Buffer (Used + 1 .. Buffer'Last),
                     Read_Last); 
                  Put_Line ("Read_Last: " & Integer'Image (Integer (Read_Last)));

                  if Read_Last = 0 then
                     Put_Line ("Client closed connection.");
                     Used :=0 ;
                     Done := True;
                  else
                     Used := Used + Read_Last;
                     Put_Line ("Used = " & Integer'Image (Integer (Used)));
                  end if;
               end;

               -- Process any complete messages
               while Used >= 6 loop
                  declare
                     Msg_Bytes : Stream_Element_Array (1 .. 6);
                  begin
                     Msg_Bytes := Buffer (1 .. 6);
                     Process_Message (Msg_Bytes);

                     if Used > 6 then
                        Buffer (1 .. Used - 6) := Buffer (7 .. Used);
                     end if;
                     Used := Used - 6;
                     Put_Line ("At end of decode, used = " & Integer'Image (Integer (Used)));
                  end;
               end loop;

            exception
               when Socket_Error =>
                  Put_Line ("Socket error occurred. Closing connection.");
                  Done := True;
               when others =>
                  Put_Line ("Unexpected error; closing client.");
                  Done := True;
            end;
         end loop;

         Close_Socket (Client);
         Put_Line ("Client disconnected, waiting for next...");
      end;
   end loop;

   Finalize;
end Bridge;
