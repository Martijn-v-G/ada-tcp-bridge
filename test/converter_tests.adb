with Converter.Msg_Converter;
with Messages.Message_Ping;
with Messages.Message_Pong;
with Messages.Message_Types;
with Interfaces; use Interfaces;
with Ada.Streams; use Ada.Streams;
with AUnit.Assertions; use AUnit.Assertions;

package body Converter_Tests is

   package Ping renames Messages.Message_Ping;
   package Pong renames Messages.Message_Pong;

   procedure Test_Convert_Ping_To_Pong (T : in out AUnit.Test_Cases.Test_Case'Class) is
      Msg_In : Ping.Message := (Hdr => (Msg_Type => 1), Payload => "HELO");
      Msg_Out : Pong.Message := Converter.Msg_Converter.To_Pong(Msg_In);
   begin
      Assert (Msg_Out.Payload = "OLEH", "Unexpected payload mismatch");
      Assert (Msg_Out.Hdr.Msg_Type = Messages.Message_Types.Message_Type_Pong, "Unexpected Mesage Type");
   end Test_Convert_Ping_To_Pong;

   procedure Test_Convert_Pong_To_Ping (T : in out AUnit.Test_Cases.Test_Case'Class) is
      Msg_In : Pong.Message := (Hdr => (Msg_Type => 2), Payload => "OLEH");
      Msg_Out : Ping.Message := Converter.Msg_Converter.To_Ping(Msg_In);
   begin
      Assert (Msg_Out.Payload = "HELO", "Unexpected payload mismatch");
      Assert (Msg_Out.Hdr.Msg_Type = Messages.Message_Types.Message_Type_Ping, "Unexpected Mesage Type");
   end Test_Convert_Pong_To_Ping;

   -- Register test routines to call
   procedure Register_Tests (T: in out Converter_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Convert_Ping_To_Pong'Access, "Test convert Ping to Pong message");
      Register_Routine (T, Test_Convert_Pong_To_Ping'Access, "Test convert Pong to Ping message");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: Converter_Test) return Test_String is
   begin
      return Format ("Converter Tests");
   end Name;

end Converter_Tests;
