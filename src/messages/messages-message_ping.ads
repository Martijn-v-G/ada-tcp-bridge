with Interfaces; use Interfaces;

package Messages.Message_Ping is
   type Header is record
      Msg_Type : Unsigned_16;
   end record;
   for Header use record
      Msg_Type at 0 range 0 .. 15;
   end record;
   for Header'Size use 16;  -- bits (2 bytes)
   
   type Message is record
      Hdr  : Header;
      Payload : String(1 .. 4);
   end record;
end Messages.Message_Ping;
