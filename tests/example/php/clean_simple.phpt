--TEST--
Test showing the --CLEAN-- section
--FILE--
<?php
$filename = __DIR__ . '/file-that-should-be-deleted';

file_put_contents($filename, "This file should be deleted!\n");

echo file_get_contents($filename);
?>
--EXPECT--
This file should be deleted!
--CLEAN--
file-that-should-be-deleted
