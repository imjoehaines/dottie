--TEST--
Test 'require' works and can be relative to the test file
--FILE--
<?php
var_dump(class_exists(CoolClass::class));

require __DIR__ . '/CoolClass.php';

var_dump((new CoolClass())->isCool());
?>
--EXPECT--
bool(false)
bool(true)
