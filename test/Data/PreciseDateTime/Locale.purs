module Test.Data.PreciseDateTime.Locale.Spec where

import Prelude

import Data.Decimal (fromInt)
import Data.DateTime.Locale (LocalValue(..), Locale(..))
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.PreciseDateTime (PreciseDateTime)
import Data.PreciseDateTime as PDT
import Data.PreciseDateTime.Locale (fromRFC3339String, toRFC3339String)
import Data.RFC3339String (RFC3339String(..))
import Data.Time.Duration as Dur
import Data.Time.PreciseDuration as PD
import Test.Data.PreciseDateTime.Spec (dateStringFixture, preciseDateTimeFixture)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

withTZ :: Int -> PreciseDateTime -> Maybe (LocalValue PreciseDateTime)
withTZ hrsTZ = map (LocalValue (Locale Nothing (Dur.convertDuration (Dur.Hours (toNumber hrsTZ)))))
               <<< PDT.adjust (PD.hours (fromInt (negate hrsTZ)))
withTZMins :: Int -> PreciseDateTime -> Maybe (LocalValue PreciseDateTime)
withTZMins minsTZ = map (LocalValue (Locale Nothing (Dur.convertDuration (Dur.Minutes (toNumber minsTZ)))))
               <<< PDT.adjust (PD.minutes (fromInt (negate minsTZ)))

spec :: forall r. Spec r Unit
spec =
  describe "LocalPreciseDateTime" do
    it "fromRFC3339String" do

      fromRFC3339String (RFC3339String $ dateStringFixture <> "+08:00")
        `shouldEqual` withTZ 8 (preciseDateTimeFixture 0 0)

      fromRFC3339String (RFC3339String $ dateStringFixture <> "-08:00")
        `shouldEqual` withTZ (-8) (preciseDateTimeFixture 0 0)

      fromRFC3339String (RFC3339String $ dateStringFixture <> "Z")
        `shouldEqual` withTZ 0 (preciseDateTimeFixture 0 0)

      fromRFC3339String (RFC3339String $ dateStringFixture <> "-00:00")
        `shouldEqual` withTZ 0 (preciseDateTimeFixture 0 0)

      fromRFC3339String (RFC3339String $ dateStringFixture <> "+00:00")
        `shouldEqual` withTZ 0 (preciseDateTimeFixture 0 0)

      fromRFC3339String (RFC3339String $ dateStringFixture <> "-00:01")
        `shouldEqual` withTZMins (-1) (preciseDateTimeFixture 0 0)

    it "toRFC3339String" do
      toRFC3339String (LocalValue (Locale Nothing zero) (preciseDateTimeFixture 0 0))
        `shouldEqual` RFC3339String (dateStringFixture <>".0Z")

      toRFC3339String (LocalValue (Locale Nothing (Dur.convertDuration (Dur.Hours 4.0))) (preciseDateTimeFixture 0 0))
        `shouldEqual` RFC3339String (dateStringFixture <>".0+04:00")
