--TEST--
Test showing the --CLEAN-- section
--FILE--
<?php
$filename = __DIR__ . '/file-that-should-be-deleted';

var_dump(file_exists($filename));

file_put_contents($filename, "This file should be deleted!\n");

echo file_get_contents($filename);
?>
--EXPECT--
bool(false)
This file should be deleted!
--CLEAN--
<?php
unlink(__DIR__ . '/file-that-should-be-deleted');
?>
