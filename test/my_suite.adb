with AUnit.Test_Suites;
with Codec_Tests;
with Converter_Tests;

package body My_Suite is
   use AUnit.Test_Suites;

   -- Statically allocate test suite:
   Result : aliased Test_Suite;

   --  Statically allocate test cases:
   Test_Case_1 : aliased Codec_Tests.Codec_Test;
   Test_Case_2 : aliased Converter_Tests.Converter_Test;

   function Suite return Access_Test_Suite is
   begin
      Add_Test (Result'Access, Test_Case_1'Access);
      Add_Test (Result'Access, Test_Case_2'Access);
      return Result'Access;
   end Suite;
   
end My_Suite;