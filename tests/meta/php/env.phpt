--TEST--
Test getenv can fetch values from the '--ENV--' section
--FILE--
<?php
echo getenv("ABC"), "\n";
echo "hello ", getenv("HELLO"), "\n";
?>
--ENV--
ABC=123
HELLO=world
--EXPECT--
123
hello world
