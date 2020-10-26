--TEST--
Test 'echo'
--FILE--
<?php
echo "Hello";
echo ", World!\n";
?>
--EXPECT--
Hello, World!
