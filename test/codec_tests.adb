with Codec.Ping;
with Messages.Message_Ping;
with Interfaces; use Interfaces;
with Ada.Streams; use Ada.Streams;
with AUnit.Assertions; use AUnit.Assertions;

package body Codec_Tests is

   package Ping renames Messages.Message_Ping;

   procedure Test_Encode_Decode (T : in out AUnit.Test_Cases.Test_Case'Class) is
      Msg    : Ping.Message := (Hdr => (Msg_Type => 1), Payload => "HELO");
      Bytes  : Ada.Streams.Stream_Element_Array := Codec.Ping.Encode (Msg);
      Result : Ping.Message := Codec.Ping.Decode (Bytes);
   begin
      Assert (Result.Payload = Msg.Payload, "Payload mismatch");
      Assert (Result.Hdr.Msg_Type = Msg.Hdr.Msg_Type, "Type mismatch");
   end Test_Encode_Decode;

   -- Register test routines to call
   procedure Register_Tests (T: in out Codec_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Encode_Decode'Access, "Test Encode and Decode of Ping message");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: Codec_Test) return Test_String is
   begin
      return Format ("Codec Tests");
   end Name;

end Codec_Tests;
