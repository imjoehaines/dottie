# dottie

Dottie is a test runner for PHPT-like tests that currently supports PHP and Ruby

## What is a PHPT test?

PHPT is a file format that includes:

- a test name
- some code to run
- the expected output of that code

For example:

```phpt
--TEST--
Test 'echo'
--FILE--
<?php
echo "Hello, World!\n";
?>
--EXPECT--
Hello, World!
```

PHPT tests are used to test the PHP interpreter, but can be run by other PHP testing tools. However, support for similar formats does not appear to exist in most other languages

## Writing tests with Dottie

Dottie supports running PHPT tests using the `.phpt` file extension and Ruby tests using the `.rubyt` file extension

By default, Dottie will attempt to run every file ending in `.<something>t`, where `<something>` is `php` or `ruby`. Support for additional languages is planned when Dottie is a bit more mature

Dottie executes tests using your system-wide `php` and `ruby` binaries. Support for running with custom commands is planned, but not currently implemented

### The TEST section

**This section is required**

Use the `--TEST--` section to give a short description of your test. Dottie prints this when running the test, so make sure it isn't too long!

### The FILE section

**This section is required**

The `--FILE--` section is the code that will be executed, for example

```phpt
--TEST--
Test 'echo'
--FILE--
<?php
echo "Hello, World!\n";
?>
--EXPECT--
Hello, World!
```

With this test file, PHP will execute `<?php echo "Hello, World!\n"; ?>`. Note: for PHP to execute code, it must be begin with an opening PHP tag!

An equivalent Ruby test would look like this:

```rubyt
--TEST--
Test 'puts'
--FILE--
puts "Hello, World!"
--EXPECT--
Hello, World!
```

### The EXPECT section

**This section is required**

The `--EXPECT--` section contains the exact text that should have been printed to stdout/stderr by the `--FILE--` section

For example, the following RubyT test expects to see `Hello, World!` printed to stdout:

```rubyt
--TEST--
Test 'puts'
--FILE--
puts "Hello, World!"
--EXPECT--
Hello, World!
```

This **must exactly match** the combined output of stdout & stderr. If you need to test something that cannot be exactly matched (such as the current time), use `EXPECTF` or `EXPECTREGEX` instead

## Currently implemented test sections

- [x] TEST
- [x] FILE
- [x] EXPECT
- [ ] EXPECTF (EXPECT_FORMAT?)
- [ ] EXPECTREGEX (EXPECT_REGEX?)
- [ ] SKIPIF (SKIP_IF?)
- [ ] ENV
- [ ] ARGS
- [ ] XFAIL
- [ ] CLEAN
- [ ] CAPTURE_STDIO
- [ ] DESCRIPTION

Additional sections do exist in the PHPT format ([see the PHP QA reference](https://qa.php.net/phpt_details.php)) but are not planned to be supported by Dottie as they are somewhat PHP specific

## Why Dottie?

Because Dottie runs `.*t` (dot t) files
