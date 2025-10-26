with Ada.Streams; use  Ada.Streams;
with Interfaces; use  Interfaces;

package body Codec.Ping is

   ---------------
   --  Encode   --
   ---------------

   function Encode (Msg : Messages.Message_Ping.Message)
     return Stream_Element_Array
   is
      Bytes : Stream_Element_Array (1 .. 6);  -- 2 bytes header + 4 payload
      I     : Stream_Element_Offset := 1;
   begin
      -- Encode header (little endian)
      Bytes (I)     := Stream_Element (Msg.Hdr.Msg_Type and 16#FF#);
      Bytes (I + 1) := Stream_Element (Shift_Right (Msg.Hdr.Msg_Type, 8));
      I := I + 2;

      -- Encode payload (ASCII)
      for C of Msg.Payload loop
         Bytes (I) := Stream_Element (Character'Pos (C));
         I := I + 1;
      end loop;

      return Bytes;
   end Encode;

   ---------------
   --  Decode   --
   ---------------

   function Decode (Data : Stream_Element_Array)
     return Messages.Message_Ping.Message
   is
      Msg : Messages.Message_Ping.Message;
      I   : Stream_Element_Offset := Data'First;
   begin
      -- Decode header (little endian)
      declare
         Low  : Unsigned_16 := Unsigned_16 (Data (I));
         High : Unsigned_16 := Shift_Left (Unsigned_16 (Data (I + 1)), 8);
      begin
         Msg.Hdr.Msg_Type := Low or High;
      end;
      I := I + 2;

      -- Decode payload (4 ASCII bytes)
      for J in Msg.Payload'Range loop
         Msg.Payload (J) := Character'Val (Integer (Data (I)));
         I := I + 1;
      end loop;

      return Msg;
   end Decode;

end Codec.Ping;
