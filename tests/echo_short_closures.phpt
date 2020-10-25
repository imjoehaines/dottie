--TEST--
Test 'echo' with short closures
--FILE--
<?php
$a = fn() => "a";
$b = fn() => "b";
$c = fn() => "c";

echo $a(), $b(), $c(), "\n";
?>
--EXPECT--
abc
