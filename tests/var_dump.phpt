--TEST--
Test 'var_dump'
--FILE--
<?php
var_dump("Hello, World!");
?>
--EXPECT--
string(13) "Hello, World!"
