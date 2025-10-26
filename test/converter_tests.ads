with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Converter_Tests is

  type Converter_Test is new Test_Cases.Test_Case with null record;

  procedure Register_Tests (T: in out Converter_Test);
  -- Register routines to be run

  function Name (T: Converter_Test) return Message_String;
  -- Provide name identifying the test case

  -- Test Routines:
  procedure Test_Convert_Ping_To_Pong (T : in out Test_Cases.Test_Case'Class);
  
end Converter_Tests;
