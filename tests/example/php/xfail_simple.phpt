--TEST--
Test the XFAIL section works
--FILE--
<?php
echo "This doesn't match the --EXPECT-- section\n"
?>
--XFAIL--
This test is expected to fail
--EXPECT--
This should match the output of --FILE--, but it does not!
