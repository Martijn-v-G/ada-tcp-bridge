with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Codec_Tests is

  type Codec_Test is new Test_Cases.Test_Case with null record;

  procedure Register_Tests (T: in out Codec_Test);
  -- Register routines to be run

  function Name (T: Codec_Test) return Message_String;
  -- Provide name identifying the test case

  -- Test Routines:
  procedure Test_Encode_Decode (T : in out Test_Cases.Test_Case'Class);
end Codec_Tests;
