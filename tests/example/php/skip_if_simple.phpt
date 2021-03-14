--TEST--
Test simple skipped test (PHP, SKIP_IF)
--FILE--
<?php
echo "oh no";
?>
--SKIP_IF--
<?php
echo "SKIP!\n";
?>
--EXPECT--
this doesn't match the file :O
