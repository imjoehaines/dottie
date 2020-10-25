--TEST--
Test simple skipped test (PHP)
--FILE--
<?php
echo "oh no";
?>
--SKIPIF--
<?php
echo "SKIP!\n";
?>
--EXPECT--
this doesn't match the file :O
