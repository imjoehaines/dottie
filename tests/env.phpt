--TEST--
Test $_ENV is populated by the '--ENV--' section
--FILE--
<?php
echo $_ENV['ABC'], "\n";
echo "hello ", $_ENV["HELLO"], "\n";
?>
--ENV--
ABC=123
HELLO=world
--EXPECT--
123
hello world
