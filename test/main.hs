module Main where

import Control.Exception
import Control.Concurrent
import Control.Logging
import Prelude hiding (log)
import Test.Hspec

tryAny :: IO a -> IO (Either SomeException a)
tryAny = try

main :: IO ()
main = hspec $ do
    describe "simple logging" $
        it "logs output" $ (withStdoutLogging :: IO () -> IO ())  $ do
            log "Hello, world!"
            timedLog "Did a good thing" $ threadDelay 100000
            _ <- tryAny $ timedLog "Did a bad thing" $
                threadDelay 100000 >> error "foo"
            _ <- tryAny $ errorL "Uh oh"
            return ()
