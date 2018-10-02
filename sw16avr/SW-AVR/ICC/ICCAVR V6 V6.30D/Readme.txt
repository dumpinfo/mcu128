ICCAVR Readme file

Make sure you subscribe to the icc-avr mailing list for program 
update announcements. Refer to http://www.dragonsgate.net/mailman/listinfo
for details.

AVR Starter Kit users should read the file \icc\readme_avrkit.doc

Outstanding Bug List (we are working on resolving it):
- if you use the ++ pre increment operator on a volatile var in an 
  expression context, the wrong value is used, e.g.
	volatile int i;
	...
	if (++i == ...

CHANGE LOGS 
05/11/2004 - V6.30D
  IDE
    - Fixed entry for AT43USB320
    - AppBuilder updates, including for the newer megas that UBRRH and UCSRC 
      share the same IO address
    - Project file now stores the name of the Device, meaning that it is less
      likely (after this release) to get "Device List Changed" message.
    - Added support for %P (project name in the output directory) and 
      %o (output directory name) in Project->Options->Compiler->"Execute
      Command After Successful Build" edit box
  Compiler
    - Added support for "#pragma lit:<name>" for placing data such as
        const <datatype> <var_name...>
      into a specific named area instead of the default "lit" area. Use
      "#pragma lit:lit" to switch back to the default area.
  Header File
    - Added iocan128v.h
  Linker (Code Compressor)
    - Disabled JMP->RJMP optimization if the target is out of range
    - Changed ERROR to WARNING for any out of text area (R)CALL/JMP in case
      if the instruction is intended to target another area such as the
      bootloader
    - Allows JMP to any target if it is surrounded by the .nocc_start and
      .nocc_end asm pseudo-ops

4/12/2004 - V6.30C
  [ NEW method to disable/enable Code Compressor
    asm(".nocc_start");
    ...
    asm(".nocc_end");

    This is better than the previous method since no instruction bytes
    is wasted and you may have RETURN in between. The macros in macros.h
    COMPRESS_DISABLE and COMPRESS_REENABLE has been replaced and redefined
    by NOCC_START() and NOCC_END() macros
    
    If you are using the old scheme in your asm code, you should change it
    to use the new directives ASAP as the old style will be deprecated!!
  ]
  IDE
    - Added AppBuilder updates and support for M8535, T13, T2313, M64,
      M48, M88 and M168. AppBuilder now supports all devices on the Device
      List.
    - The starting addresses for M8535 and M8515 were incorrect, conflicting
      with the interrupt vectors.
    - Added ISP support for T13, T2313, M48, M88 and M168. ISP now supports
      all devices on the Device list.
  Compiler
    - fixed a long standing limitation in that an "if condition" that is 
      translated into a SBRx or SBIx instruction was always using a RJMP
      instruction to try to reach the end of the block. This generates an
      error if the body of the conditional exceeds 4K word.
    - the fragment
        int *p;
        char c = (char)*p++;
      when compiling for AVR Enhanced Core was generating an assertion
    - Register History was not invalidating global/static vars cached in
      registers when there is a pointer write.
    - Peephole optimization for
        MOV Rt,Ry
        CP Rt,Rx
      ==>
        CP Ry,Rx
     
      was not considering the possibility that Rx can also be the same as Rt
  Linker/Code Compressor
    - interrupt vectors for bootloader were not handled correctly
  Library
    - the string functions were incorrectly using signed comparison instead 
      of unsigned comparisons.

02/05/2004 - V6.30B
  IDE
    - AppBuilder fixes for M169 LCD
    - Scroll mouse now works correctly under all OS and mouse brands
  Compiler
    - Fixed a bug where the compiler was not copying stacked arguments to 
      registers if the function is a MONITOR function (normal functions are
      fine).
    - The debug line information was accidentally foobar'ed for the body
      of for loops. This affected listing file and the debug information
    - "if (m > a[i])" was generating the incorrect unsigned branch if both
      "m" and "a[i]" are signed char types.
  Library
    - Fixed bug in cstrncmp (thanks JA)
  Utilities
    - Include ICCAVRMapFileSummy.exe (thanks JA)

01/17/2004 - V6.30A
  IDE
    - Added device support for ATMega48, M88, and M168. No support for ISP
      and AppBuilder yet.
    - Changed STK500 ISP Lock/Fuse Bits write to encode the bit values in 
      HEX as required by the stk500.exe program
  Header Files
    - Added iom48v.h, iom88v.h, and iom168v.h (once again thanks to JA)

12/15/2003 - V6.30
  - now a single distribution can also work as the network dongle version
  IDE
    - Added IDE support for Tiny13, Tiny2313, no support for ISP and 
      AppBuilder for them yet (will be done ASAP).  Added support for 
      AT86RF401, AT43USB355, and AT43USB320A.
    - Added AppBuilder support for M169 and M8515. To Be Done: tiny13, 
      tiny2313, M8535, and M64. Miscellaneous AppBuilder bug fixes.
    - Reverted to use STK500.exe instead of builtin ISP support
  Compiler
    - lcc 4.2 source tree merge. This *MAY* fix the bug with source files 
      residing in remote NT network drives causing spurious 
      "illegal charcaters \0" error.
    - Fixed a rare register history bug where the "stz" was not invalidating
      Y+d references even though Z and Y are aliased.
    - Fixed a register history bug where Z+d offset propagation optimization
      was not correctly marking Z has been updated.
  Assembler
    - Fixed a buffer overflow bug (line > 1024 chars, mainly from C comment
      lines) causing all sorts of spurious error msgs
  Linker
    - Make Code Compressor compatible with any JMP/CALLs that are outside
      of the text area
    - Code Compressor no longer eliminates NOPs (timing loop etc.)
  Header Files
    - Added iot13v.h and iot2313v.h, aiot13.s and aiot2313.s
  Library
    - Added cstrncpy
    - Thanks to JA, all string functions except for strtok are now written 
      in assembly!
    - printf was not supporting field width for %c (large and FP printf only)
    - Added EEPROMread_M169, EEPROMwrite_M169, EEPROMReadBytes_M169, and
      EEPROMWriteBytes_M169 since the M169's EE?? IO register locations are
      different from other AVRs. You do NOT have to do anything, if you use
      the IDE and "#include <eeprom.h>". The correct functions will be called
      when you use EEPROMread, EEPROMwrite, EEPROMReadBytes and 
      EEPROMWriteBytes.

8/18/03 - V6.29
  IDE
    - V3.00 of dongle driver
    - File->SaveAs now asks for confirmation if the file already exists
    - Added support for direct interface to the STK500 ISP w/o the use of
      Atmel STK500.exe program.
    - Added support for programming the Lawicel's stAVeR boards using the
      serial bootloader.
    - Added "Salvo Config" tab to Project->Options
    - Added (Directory) Browse buttons to the "PATHS" tab in
      Project->Options.
    - Alt+P, Alt+E, and Alt+S were not activating the menus [ bug introduced
      with Studio+Debugger support]
    - Added Tools->EnvOptions->Terminal->Font..

  Compiler
    - Under some rare condition, the generated code might trash the 
      destination register of a load:
         return u->buff[u->out];  // out is more than 64 bytes away from u
    - The compiler incorrectly asserted when there are many function 
      arguments that are themselves functions returning long data 
    - Some combinations of signed and unsigned 8 bits divide/moid were using
      the incorrect 8 bit div/mod
    - A rare spilling bug was fixed
    - #pragma monitor function was accessing the first 4 argument bytes 
      incorrectly if they were left on the stack
  Linker
    - Make Code Compressor compatible with bootloader
  Assembler
    - the assembler was crashing whenever it tried to emit an error msg. (bad
      code cleanup)

6/30/03 - 6.28C
  IDE
    - AppBuilder for some of the CPUs were generating incorrect values for
      the TIMER2 (typos in .cpu files)
  Compiler
    - Fixed Register History not tracking the high byte of a STD (word)
      to a stacked location correctly 
    - the low level FP add/mul/div/etc. functions make use of R16-R19 which
      the compiler was not preserving. This would cause problems if R18-19
      were already being used for the 2nd function argument.
  Assembler
    - Wrong relocation stream could be generated for immediate instructions
      causing the linker to assert
      [ introduced in 6.28 ]
  Library
    - signed mod8 operations gave incorrect signs

  Assembler
    - wrong relocation stream could be generated for .word directives
      [ introduced in 6.28 ]

  Linker
    - if a "Unused ROM Fill Pattern" is specified, the hex file may contain
      extra stuff beyond the device's address space

6/10/03 - 6.28A
  IDE
    - Enabled support for FLASH Studio+ debugger menu when Studio+ is 
      installed
    - Added AppBuilder support for Tiny26.
    - The ISP Fuse/Lock bits writes were incorrectly setting the high byte
      of the low word to zero all the time.

  Compiler
    - Fixed register history not properly updating the end tick of a lds.
      This shows up in
      float glob_f1, glob_f2;
      ... glob_f1 = 0; glob_f2 = glob_f1 * glob_f1;
    - Fixed bugs in code patterns:
        <unsigned> = (<expr> << 8) | <byte>;
    - Changed "unknown pragma..." from error to warning
  Code Compressor
    - Made CC run faster in the cases where the input is large (> 128K bytes
      of object code)
  Libraries
    - Signed % operations with negative operands were giving incorrect
      signed results for both 16 and 32 bits (div16/mod16 and div32/mod32)

4/28/03 - 6.28
  Libraries
    - DUE TO POPULAR DEMAND, _textmode is now set to zero by default, meaning
      that default putchar will not add a LF after seeing a CR and therefore
      is more suitable for binary output
    - Added
        char *cstrstr(char *ramstr, const char *romstr);
          finds romstr in ramstr
        char *cstrstrx(char *ramstr, const char *romstr);
          finds romstr in ramstr using elpm instruction
        and faster version of strstr();
      All 3 written in assembly by JA. Thanks! [ NEED TO ADD TO NEW HELP
      FILE ]
  IDE
    - Added DEVICE entries for mega8515, mega8535, and mega64. 
    - Added ISP support for Tiny26, M8515, M8535, M162, M169 and fixed M32.
      [ TINY26 TESTED, OTHERS NOT TESTED ]
    - Modified builtin ISP to use Atmel convention for fuse/lock bits: 
      0 - programmed, 1 - unprogrammed. Modified ISP dialog box note to
      match.
    - AppBuilder: added support for M162. Fixed M8 bugs, timer CTC bug.
      Reduced memory usage, and added new item in options menu to load the 
      last configuration
    - AppBuilder: TWI, Timer and Crystal update bug fixes
    - Added ISP support for the ability to PRESERVE existing EEPROM content,
      or to specify a known EEPROM file, in addition to the existing behavior
      of always programming the EEPROM file (<project>.eep) if it exists.
    - Extensive cleanup of ISP code
  Compiler
    - Improved constant folding for exprs:
	(expr OP const) OP const
      and where OP is a commutative operator
    - Added capability to track up to 2 external aliases in the register
      history
    - fixed rare bug in register history WRT lds(l) caching
    - fixed bug in register history where ptr store was not invalidating
      the pointer cached value.
    - division of unsigned byte by small power of 2 constants are now done
      by logical right shifts
    - Added support for #pragma monitor <func>*. A monitor function pushes
      SREG on entry and disable interrupt. At exit, SREG (and the interrupt
      state) is restored. This is useful for writing RTOS.
    - Added using OUT instructions for word write to IO registers (somehow
      it was never done before, oops)
    - Fixed a problem where sometimes the
	long *long_ptr; .... *long_ptr++;
      optimization was incorrectly fetching the result into a word register
      instead of long "register." e.g. it caused problem with
        tmp += *long_ptr++;
  Linker
    - fixed coff.c assertion on function returning "const pointer to ..."
      when debugging is enabled
    - "Device ??% full" message now takes into account of the initial
      start address of the flash address, e.g. it is accurate even for the 
      bootloader application build
  Code Compressor
    - Some programs > 128K bytes were getting assertions of CALL/JUMP targets
      out of range
    - Fixed bugs w/ CALL/JUMP > 128K bytes
  Listing File Generator
    - Changed STD to use standard Atmel operand order
    - Deleted "P" from IN/OUT port number prefix
  Header Files
    - PE1 --> UPE1 in iom162v.h
    - PE0 --> UPE0 in iom162v.h

3/06/03 - 6.27A
  Compiler
    - fixed assertion in the register history module (introduced 6.27)
    - fixed bug in register history module where a function call did not
      invalidate all pointer references in the register table (introduced
      6.27)

3/04/03 - 6.27
  IDE
    - Find in Files went into infinite loop if a pattern is found in the last
      line of a file
    - AppBuilder: Added support for 14.7456MHz crystal
    - User supplied libs are now specified before the default libraries
  Compiler
    - Now warns about uninitialize local vars and extend the lifetime to
      cover the entire function. Used to generate garbage register allocation 
      for uninitialized locals.
    - Improved Register History, meaning that less register moves and loading
      are being done.
    - calling a function with two or more arguments that are function
      returning long was generating bad code:
          long a(), b();    foo(a(), b());
    - tst(w) elimination was incorrectly eliminating a "tst" instruction
      when the previous instruction is a word instruction
  Code Compressor
    - Fixed couple assertions with Code Compressor
  Library
    - math.h now uses the FAST sin/cos/exp/etc.
    - the routine elpm16 was accidentally named lpm16 and overrode lpm16 in 
      the library
  [ dongle 2.53B4 ]

1/10/03 - V6.26C
  IDE
    - [from 6.26B ] The new dongle wrapper was causing the IDE to run very
      slowly on some W95/W98 systems.
    - General speed cleanup
    - If you specify an output directory that does not exist, it might get
      created under \icc\bin in addition to the project directory.
    - The starting address for M169 was set 2 bytes too small
  Header Files
    - iom8515v.h was missing PORTA definitions
  ilibw
    - Increased the number of input .o files to 256

1/06/03 - V6.26B
  [ new dongle driver 2.53 ]
  [ an experimental set of faster high level math functions (sin/cos/exp/etc.)
    is available when you #include <mathx.h> instead of <math.h>. Please let
    me know what they work for you. ]

  IDE
    - C file dependency now calls iccavr instead of icpp so that _AVR and
      __IMAGECRAFT__ are #define'd.
    - [ bug introduced in 6.25B or 6.25C] The IDE would incorrectly always
      invoke the builtin editor when you double click on an error msg.
  Linker
    - use of bitfield generated an assertion in COFF debug generation
      (introduced in 6.26A)
    - Code Compressor incorrectly WARNED about CALL/JMP targets out of
      range and generated incorrect code
    - Fixed rare occurrence of code not being put in a few bytes around
      the 64K byte boundary.
  Library
    - printf %e,%f etc. were printing extra empty spaces after the output
    - faster / smaller abs()


11/25/02 - V6.26A
  [ PRO ONLY - structure member expansion is now working correctly with
    AVR Studio 4.06 (and above) ]

  IDE
    - Fixed bugs in AppBuilder: M8 - buadrate was not setup correctly. M16 -
      PORTA was missing
    - Added device entry for M169
    - The IDE incorrectly disallowed a New Project w/ spaces/tabs
    - Added selection for different AVR Studio versions in 
      Project->Options->Compiler

  IDE/Compiler/Linker
    - Project->Options->Compiler now lists choices for different Atmel Studio 
      versions
    - Structure member expansion works w/ Atmel Studio 4.06
  Compiler
    - the compiler was ignoring the user defined casts:
        ((signed char)char_1 < (signed char)char_2) ? ....
      and was incorrectly generating an unsigned branch
    - Stopped generating long immediate logical and arithmetic ops since it
      can cause the register allocator to run out of high registers (was
      introduced in 6.26).
  Linker
    - bug introduced in 6.26? 6.26 allowed an object file to cross the 64K
      byte boundary, but the hex/COFF files generated were incorrect
  Code Compressor (PRO)
    - the Code Compressor was incorrectly deleting some of the newer mega 
      instructions such as MULSU
  Library
    - printf %f now fully supports field width and precision. Added %e %E %g 
      and %G
    - s/scanf were incorrectly returning the total number of characters
      consumed. They now return the number of successful conversions.
    - ftoa of 0 incorrectly gave out of range error

09/30/02 - V6.26
  The COMPILER CAN NOW BE INSTALLED IN PATH WITH SPACES. You may also use
  spaces in your source file names, but probably not in header file names.

  - some minor formatting changes introduced in 6.25C turns out to be
    incompatible with Flash's Studio+:
    = hex line is now revered back to 20 bytes per line
    = listing file is now reverted to use 4 spaces for the disassembly line
  IDE
    - Code Browser bug fixes
    - Added support for spaces in Paths
    - Changed STK-500 ISP to allow users to specify the path to the Atmel
      stk500.exe program. This is in the Tools->EnvironmentOptions->ISP
      tab.
    - Added Code Browser sorting control in the Tools->EnvOptions->General
      tab.
  Compiler
    - The peephole optimizer was incorrectly handling a long expression 
      casting to a byte in some situations.
    - Better code for long operations with constant operands
    - Data declarations inside nonstandard data area (e.g. 
      #pragma data:eeprom) used to require the data to be initialized. 
      Otherwise, it used to go into the BSS area.
    - The fix to doing byte fetch on single byte struct were causing incorrect
      diagnostics when accessing fields of a single byte union inside a
      structure.
  Assmbler
    - Enable .long directive
    - In some rare condition, if a file contains XCALL instructions, the 
      debug info may be off by one byte (e.g. breakpoints end up in the
      middle of an instruction).
  Linker
    - (PRO Code Compressor) fixed bugs on compressing programs that
      exceeds 128K prior to compression.
  Header Files
    - revert io???.h (not the new io???v.h) to the original version.
  Libraries
    - Enhanced Core long multiply routines were incorrect for negative
      operands
    - Added %s to scanf
  Listing File
    - Correct disassembly for LPM Rx,Z(+) and proper display of STS operands

07/20/02 - V6.25C
  [ EXPERIMENTAL - ] Added Structure debugging info for AVR Studio COFF
  format. Note: Neither Studio 3.54 or 4.04 accepts structure debug
  info yet.

  IDE
    - Added Options->Target->[Use ELPM]. When checked, this generates the
      compiler flag (-Wf-use_elpm, or -use_elpm) and the compiler will use
      elpm instead of lpm. IDE selects this if you select bootloader option
      and if your target device has > 64K bytes of flash. This allows
      constant items to be accessed correctly for bootloader on these
      devices.

      - crtboot.o is used for bootloader for < 64K devices. It is the same
        as the standard crtavr.s except that the IVSEL regisetr is set to
        change the interrupt vectors to the bootloader area. If this is
        undesirable, you can always enter "crtavr.o" as the "Non-Default
        Startup File"
      - crtboothi.o is used for bootloader for > 64K devices. elpm is used
        and RAMPZ is set to 1.
    - Generates -bvector:<bootloader addr> to relocate vector to the right
      location. Note: this means normal #pragma interrupt_handler <func> 
      mechanism can be used to define bootloader vectors.
    - Added File->CompilerFile...->StartupToOutput. This generates the -n
      flag to the assembler which is required to assemble the startup file
  Linker
    - HEX records are output in 16 byte chunks instead of 20 bytes for better
      compatability with some file loaders.
  Library
    - Added libcavrhi.a, a version of libcavr.a that uses ELPM.
  Header Files
    - Thanks to Johannes Assenbaum (again): added ioRF401v.h ioUSB??v.h and
      assembly header files for the Atmel RF and USB chips w/ AVR core.

06/10/02 - V6.25B
  IDE
    - Fixed AppBuilder for M32 and M323
    - Added support for crtboot.o when building bootloader.
    - Fixed ISP programming of > 64K bytes when not using the STK-500
    - Improved "Find In Files." No longer rely on external grep program.
  Compiler
    - When passing an UNSIGNED long as the first argument to a function
      that takes an unsigned byte as the first arugment, R18/R19 are
      accidentally trashed.
  Library
    - Added setjmp/longjmp
    - Added new/faster/smaller/better ftoa

05/21/02 - V6.25A
  IDE
    - Added FirstERR/NextERR buttons and menu items (Atl-F7, Alt-F8).
    - Changed Function addresses in Code Browser to word address
  Compiler
    - Eliminated couple peephole errors where if the result of a word
      operation is stored into a byte, the operation was done in byte
      even is the word operation is needed (e.g. to propagate the value
      from the upper byte such as right shift)
    - Register History did not reset the register table when encountering
      an internal label (only within <var> != 0 expressions). This caused
      problems with lds register history tracking.
    - Additional rare peephole/register history fixes 
  Linker
    - Allow out of text area jumps when the Code Compressor is on. This
      allows jumps to external code fragment such as bootloader etc. A
      warning is emitted.
    - additional code compressor fixes RCALL'ing some of the FP math 
      routines

03/11/02 - V6.25
  IDE
    - Added Code Browser support!
    - When using the STK-500 ISP, the IDE no longer generates the -d flag
      (device) if the Project Device is set to Custom. The correct device 
      can be set by hand in the "Additional STK-500 arguments" edit box.
    - the bootloader size was not reloaded correctly when opening an old
      project
    - the files appm8.cpu, appm16.cpu and appm32.cpu were not included in 
      the 6.24B release (for AppBuilder)
    - the starting addresses for mega8 and mega16 were incorrect
  Compiler
    - use Z+/X+ as much as possible for *q++ type of expressions
    - Eliminate redundant moves (def-def) to registers 
    - Better code for byte vars that were captured in an integer Common
      Subexpression (e.g. c--; )
    - Fixed a 6.24B regression where comparing an unsigned byte with 
      integer constant between 128 and 255 were (inefficiently) promoted
      as int compare instead of byte compare
    - Generating code for enhanced core occasionally generated the error
      "register 17 not valid"
    - FP Multiply now uses the MUL instructions for enhanced core - more
      than twice as fast as without using the MUL instruction!
    - Long Multiply now uses the MUL instructions for enhanced core - more
      than twice as fast as without using the MUL instruction!
    - Register History was not invalidating the upper byte of an aliased
      register pair correctly
  Code Compressor
    - fixed a rare bug with 8K wrapping with calls to some library routines.
  Listing File Generator
    - If you have an absolute code section (e.g. a bootloader) and if you
      turn on Compiler Options->Output->COFF or COFF/HEX, then
      the listing file generator may crash trying to disassembly non-existent
      code between the valid text area and your bootloader

01/24/02-  V6.24B
  IDE
    - if a src file that is not in the project directory contains a syntax
      error, and if the src file is already opened, the IDE incorrectly
      opened another copy of the file if you click on the error msg.
    - Added a checkbox in Project->Options->Compiler for "int size enum"
      for backward compatibility
    - various AppBuilder fixes, plus added support for mega8 and mega16
  Compiler
    - Gives error if you try to declare const object with local storage 
      class
    - It is now OK to have non-initialized items in the abs_address pragma
      region
    - Added a flag for -intenum for int size enum (default char size if
      possible)
    - If the result of an arithmetic operation with 2 long operands is casted
      into unsigned long, the arithmetic was incorrectly done as int 
      arithmetic instead of long arithmetic.
    - If the address of a global var. is saved in R30/R31 and loaded into 
      a register, and then the global var. is updated, Register History did 
      not invalidate the saved register.
    - Under Enhanced Core code generation, a multiply of an unsigned byte
      with a signed byte extending to 16 bits (e.g. a byte array index) was
      using the wrong MUL instruction variant. Thus if the unsigned byte
      has the high bit on, the result was incorrect.
    - Disable mul->shift optimization if enhanced core is used
    - When seeing an expr "V1 <op>= R0" (e.g. R0 as a result of a mul
      instruction under enhanced core), if V1 is spilled, the spiller
      generated incorrectly code
  Linker
    - STD linker now allows 64K bytes of code anywhere (e.g. OK to use STD
      to write Boot Loader code)
    - The Code Compressor was sometimes incorrectly complaining about out 
      of range interrupt vectors when the -W flag is on.

01/02/02 [ Happy New Year! ] V6.24A 
  Added I2C, Real Time EEPROM, LCD functions in \icc\examples.avr
  Compiler
    - fixed a rare assertion
    - fixed a rare lifetime analysis bug w/ nested loops and switches
  IDE
    - ISP now supports M128, M8 and M32 (already supported the M16x)
    - Project file names are now stored using relative PATHs, making it
      easy to move projects
    - new AppBuilder - M128 support, and you can now load/save configurations!
    - you can now ^tab between the opened editors
    - revamped Find/Replace dialog, fixed FindNext errant error msg box
    - the wrong libraries were used when using "Do not Use R20..23" option
      AND the long or FP printf.
    - Search for the STK500 registry entry correctly even if it is nested
  Header Files
    - new set of iom???v.h files
  Listing File Generator
    - under some rare conditions, the listing file will disassemble the
      2nd word of a 2 word instructions and show non-existence code. This
      does NOT affect the actual code being generated.

11/09/01 - V6.24 
  ADDED support for hardware parallel port and USB dongle.

  IDE
    - ISP was broken under some OS/chip due to a bad merge problem.
    - Dependency generation for the ASM include files was not using the 
      Include Paths
    - Added "Other Options" in Project->Options->Target to add any
      linker command. 

  Driver
    - now calls ilstavr directly to generate listing file.

  Compiler
    - compiler was asserting when converting an unsigned long to a float.
    - always reading low byte first in a 16-bit access in case if the
      the external is a M128 extended IO register.
    - if (++x <relop>) was broken due to too aggressive register history
      not updating lifetime

  Linker
    - linker changed name from ilinkw to ilinkavr
    - no longer calls ilstavr - done by driver

  Header
    - Added iom64.h
    - Thanks to Johannes Assenbaum (again) for revamping the header files.
      They are called io????v.h (e.g. io8515v.h) so the existing ones will
      still work. The new ones use more consistent naming schemes, especially
      WRT inetrrupt vectors. Assembly header files a????.s are also
      available.

10/5/01 - V6.23B
  Header
    - iom128.h defined PINC incorrectly

  
 - V6.23A
  IDE
    - Enables DT-006 ISP support
    - Added ATMega128:M103 compatibility mode selection and better support
      for M128
    - The ISP Hex loader was not loading Extended Segment Record (TYPE 2)
      for >64K bytes hex files correctly.

  Compiler
    - better code for function returning longs and floats
    - spill bug - when propagating R0 or R16, it should stop if it
      enables a spilled register use. (Very rare)
    - the compiler was asserting when casting a unsigned long to a pointer 
    - minor improvements to register historying
    - if-then-else code for switches of up to 12 cases

  Linker
    - the checksum for extended segment record (TYPE 2) was incorrect

  Library
    - fixed a potential sbr?/jmp pair problem in the fp2int and fp2long
      routines for ATmega only
  Header
    - Added iom8.h for ATmega8.h
    - Added extended IO registers in iom128.h

09/05/01 - V6.23
  Code for Atmel Appnote 109 (Self-Programming) has been ported to ICCAVR.
  See \icc\examples.avr\appnote109\.

  Compiler
    - small enums can now be char type.
    - function returning char type is no longer extended to 16 bit.
    - Lots of peephole improvements. Should see 1%-5% better code:
      . Z flag tracking
      . repeated register history and peepholing
      . sbr? optimizations for word vars, and branch flipping
      . call/ret ==> jmp
      . more temp register elimination --> less register moves
      . ([int/byte] << 8) | (ubyte) generates better code, also + operator.
    - Two rare case lifetime analysis bugs were fixed - 1) nested loops with 
      a variable defined only in the inner loop but is used in the outer
      loop got incorrect lifetime, 2) nested loops need the backedges
      normalized.
    - A rare case of register spilling:
	if (<spilled reg> relop <const data>) ...
      the spilled registers used R0 which trashed the result of the lpm
    - explicit cast of unsigned int to unsigned long than << 16 bit
      was generating incorrect code: l = (unsigned long)ui << 16;

  Code Compressor
    - added nop squashing after CALLs are turned into RCALLs

  Library
    - scanf %d sometimes converted the number incorrectly

  Listing File
    - listing was incorrectly for addresses > 64K bytes

07/29/01 - 6.22B [ 16th Anniversary Release ]
  [ Command line compiler only users should run the IDE at least once
    to enable new licensing scheme for the command line tools ]
  [ Unlicensed IDE now changes to a 2K demo version when it exceeds 30
    days ]

  IDE
    - Added support for ATMega323, Mega16 and Meag128
  Library
    - smaller code for integer div/mod/mul, thanks to David Raymond
    - strcpy was writing a byte too many at the end of the copy
    - added variable (*) width and precision to (s)printf (LONG and FLOAT
      versions only).
  Header Files:
    - renamed (and fixed) iom32.h to iom323.h, added iom16.h iom128.h

6/22/01 - 6.22A
  IDE
    - Added better device selection for AT94K FPSLIC devices
    - decreased the CPU load when "idling" <project tree icons update>

  Compiler
    - incorrect unsigned branch code was generated for:
        if (sc RELOP <constant>)
      for signed char variable

6/20/01 - 6.22
  Compiler
    - incorrect signed branch code was generated for:
	if (uc OP <expr>)
      for unsigned char variable used with an arithmetic operation

  IDE
    - Added support for new MegaAVRs with bootloader. You can select
      targetting either the Application Code or the Bootloader code.
    - Added support for AT94K05 devices
    - New Project list manager, thanks for Andy Clark
    - The Terminal window and the Project File window now memorize their
      sizes between invocations.
    - You can now add a command to run after a successful build
      Project->Options->Compiler
    - ISP for Mega163 now working correctly
    - ISP VerifyEEPROM now working corrctly
    - Support for STK-500 ISP
  Library
    - div8/mod8 were not saving R18 and may cause problem if it is
      used within an interrupt handler

  Deferred until 6.22A
    - [PLANNED] Support for LCLint, a program checking utility.
    - [PLANNED] Add LCD library

05/11/01 - 6.21G
  Listing File Generator
    - if you have multiple source files that contain ONLY data definition
      statements, the sort function went to la-la land.

05/10/01 - 6.21F
  IDE
    - Added the feature to automatically rebuild a project when a new
      compiler is installed.
  Linker
    - the linker was crashing when generating debug information for
      assembler include file

05/03/01 - V6.21E 
  Compiler
    - multiply by power of twos are now done by shifts
    - more (faster) inline code for shifting
    - suboptimal code was generated for routines with unused local
      variables
  IDE
    - Better ISP support, especially for m103 and under NT/2K
  Listing File Generator
    - No longer complains about "can't open source files..."
      for source files not in the same directory as the project file.
    - MULS[U]/MOVW are now displayed correctly
  Code Compressor
    - MOVW was not handled correctly and might be incorrectly deleted
  Header File
    - Added iom32.h for ATMega32 support
  Debug File Generation
    - Added "DIR" command in DBG format file for specifying new source
      directory.
    - Stepping into an ASM routine was not working in AVR Studio source
      code mode.

04/09/01 - V6.21D
  Fixed weird behavior of 6.21C under W98 (only). Somehow the method that
  the listing file generator was invoked was incompatible with W98. 

  Better Licensing dialog boxes. Mostly important for new users.

  IDE/Libraries
    - Added global register specific libraries (e.g. libcavrgr.a). Not doing
      so increased the size of library code.
  Linker
    - The listing file generator complained if there are more than ~15 files
      in the source project

03/27/01 V6.21C
  IDE
    - Added %p (project name) for Tool Configuration.
  Linker
    - Fixed Code Compressor Internal Assertion
    - Fixed overly aggressive assertion check on RCALL/RJMPs
  List File Generator Utility
    - a buffer was too small for long symbol names

03/19/01 V6.21B
  IDE
    - Added support for external editors TextPad and WinEdit
    - The dependcy generator was not working correctly for Assembler file with 
      .include statements with double quotes
  Compiler
    - the compiler was incorrectly generating code for saving and restoring
      R20..23 even when the switch -r20_23 (do not use R20..23) was on
    - Fix a global register allocation bug where a definition must also be 
      treated as a use
  Asm
    - Added 'c' character constant support in addition to the old syntac 'c
    - The assembler now complains if there are extra characters on the input line
    - The assembler now complains about "missing operand" instead of 
      "illegal operand" for missing operand.
  Linker
    - Generates valid listing file even if the Code Compressor is on.
    - Fixed a Code Compressor Internal Error assertion.

02/22/01 6.21A
  Compiler
    - fixed constant folding
  Library
    - csprintf was broken
    - divide -256 gives incorrect result
  IDE
    - (PRO) RCS was not working correctly

02/16/01 6.21
  C Preprocessor
    - Russian characters were causing the preprocessor to hang
    - Added vararg #define when -e flag is on:
        #define db(a, ...)  printf(a, __VA_ARGS__)
      allows db() to be called with one or more arguments

  Compiler
    - Better code for shifting 8 and 16 bits
    - Fixed a rare register allocation error
    - If a variable is assigned but not used, the code is eliminated.
    - Added -r20_23 flag. When the flag is specified, then the compiler
      will not use R20..23. This may generate slightly larger code but
      allow interrupt handler or C functions to use them as global
      registers. The libraries have been recompiled to not to use these
      registers.
    - Added
        #pragma global_register name:# name2:# ...
      to specify global registers. The pragma must appear before the
      declaration of the names. The global variables must be of char, 
      integer or pointer types. e.g.
        #pragma global_register gi:20 gc:22 gc2:23
        int gi; char gc, gc2;   // gi is R20..21, gc is R22, gc2 is R23

  Linker
    - Fixed a bug with generating incorrect COFF file for project with a
      lot of symbols.

  IDE
    - You can now use UltraEdit32 (purchased separately :-) ) "integrated"
      with the IDE. You can select different editors in
      Tools->EnvOptions->General->Editors. Future releases may include more
      editors and even tighter integration.
    - Setting an Output Directory caused File->CompileTo... to fail
    - Added Option->Target->Advanced->"Do NOT Use R20..R23"
    - Improved AppBuilder. The .cpu file documentation is at \icc\bin\cpu.txt
      for your own customizations!

01/16/01 6.20b
  Compiler
    - local register allocation fix for
            *static_var = *ptr++;
01/15/01 6.20a
  Compiler
    - Inocrrectly generated something like "ldz R16,Z-" for *p-- operation.
      AVR does not have a postdecrement mode.
    - no longer warns about unreferenced static function if the function
      is an interrupt handler
  Library
    - atof now accepts expression w/o dot. e.g. 1.0e4
  Header
    - Added UCR USR back to io4433.h
    - Added interrupt vectors #defines for iom103.h and io8535.h
        (more coming)
01/02/01 6.20
  IDE
    - Added Options->Target->FillUnusedROM to fill unused rom space with
      with user specific number
  Compiler
    - Faster and shorter long and FP constants loading code.
    - Much better code for *q++ type of operations
    - Added -e for accepting binary constants
  Library
    - Added support for stack overflow checking. Please check the WinHelp 
      file on Stack Checking Functions under Library section. See 
      \icc\examples.avr\stack.c for an example.
    - cprintf and csprintf were not honoring precision and width flags even
      under large or FP printf mode
  Linker
    - Fixed another rare Code Compressor bug for 8515.
    - Added -F<#> to fill unused ROM space

11/21/00 6.19C
  Compiler
    - accidentally broke #pragma data:eeprom

11/20/00 6.19B
  Compiler
    - Fixed a rare but critical error with functions needing more than
      63 bytes of stack space. The generated code was such that an interrupt
      could corrupt the stack.
  IDE
    - BETA release of the ISP support (Tools->ISP). NT/2K users must run
      "loaddriver" to enable parallel port access. May not work for all
      Windows or all target devices.
    - The AppBuilder now supports all AVR devices! You can change the port
      name by right-clicking on the port
  Header
    - Added io8534.h
  Library
    - Fixed rare error in FP->INT conversion

10/26/00 V6.19A
  Compiler
    - fixed an obscure register spill code problem with lpm instruction.
  Linker
    - fixed a problem with Code Compressor for 8515/8535 target
  Library
    - the multiply routine mpy16s was not saving R0/R1, which could
      cause a problem if it is used inside an interrupt handler (array 
      indexing, multiply etc.)

09/26/00 V6.19
  IDE
    - First release of the Application Builder! Currently only support
      2313/8515/Mega103. Other devices will be added later.
    - Added mega 83 and mega 163 devices
  Compiler
    - Fixed an obscure register allocation bug where sometimes R26/27
      are allocated as local registers
    - Changed back to the old behavior where #pragma interrupt_handler
      creates the vector entry
  Linker
    - Fixed a bug with the Code Compressor failing for 8515 when the space
      is about 100% with compression on
  Library etc.
    - Added iom163.h and iom83.h
    - Added _textmode variable to change the putchar mode.
        extern int _textmode;

        _textmode = 1;
      will make putchar() output a '\r' whenever it sees a '\n'

09/06/00 V6.18B 
  Preprocessor
    - now performs macro expansion even on the #pragma line. This means
      that you can use #define for the interrupt handler vector number!
  Compiler
    - fixed couple register allocation errors
  Asm
    - fixed xcall optimizaion error in rare cases
  Library
    - printf %f was broken due to the register allocation error

08/26/00 V6.18A
  IDE
    - Seems like most people prefer the old IDE look without the Workspace
      bar. Roll back to the old look.

08/23/00 V6.18
  Compiler
    - added "#pragma ctask <name> <name2>..." to specify that the
      functions should not generate register save/restor code. Useful
      for writing RTOS
    - improved register allocator by using volatile regs for global
      allocation and other tweaks
    - rcall/rjmp optimization for Mega devices
    - byte arguments no longer get extended as int (2 byte is still
      reserved but no sign/zero extension is done).
    - miscellaneous bug fixes in the peepholer.
  IDE
    - new IDE look, added a "Workspace" bar.
    - the editor now honors the editor settings even for non .c .s files.
    - project setting changes (project options and project files)
      are written to the project file immediately. No "Project->Save"
      is needed.
    - FindInFiles in now available in the STD version as well.
  Library
    - due to an assembler bug, when "external memory" is selected,
      WAIT state was always on.

06/18/00 - V6.17E
  Compiler
    - minor miscellaneous peephole optimizations added
    - initialization of local aggregrates (structs and arrays) now
      work correctly
  Library
    - faster routines for multiply

06/08/00 - V6.17D
  Compiler
    - a typo caused #pragma interrupt_handler not recognized correctly
      for the mega devices
06/06/00 - V6.17C
  Compiler/Library
    - added more support for EEPROM. See WinHelp file and eeprom.h for details:
      EEPROM_READ(int location, object)
      EEPROM_WRITE(int location, object)

      To create a <output>.eep file (starting at address 1 to work around
      an AVR hardware bug):
      #pragma data:eeprom
      int foo = 0x1234;
      char table[] = { 0, 1, 2, 3, 4, 5};
      #pragma data:data
  IDE
    - Changing the include paths now force a total rebuild

05/31/00 - V6.17B
  RCS (PRO version only)
    - checkin was broken
    - GNU diff is supplied to work with rcsdiff
  Compiler
    - an obscure bug with interrupt handlder pragma caused bad code
      generation was fixed.
    - a bug with common subexpression involving unsigned char var.
      has been fixed.
  Library
    - fp->int and fp->long conversions are now done in asm for smaller
      and faster code.
    - some floating point comparisons were incorrect

05/16/00 - V6.17A
  A typo in the library Build script caused the reset vector to use JMP 
  instruction for all targets (which is incorrect for all non-mega
  devices)

05/15/00 - V6.17
  IDE/Compiler
    - >64K addressing for mega 103 is fully supported (PRO version only).
  IDE/Asm
    - now support include path for the assembler. See Project->Options->Paths
  Library
    - putchar no longer adds a LF after a CR, which seems to do more harm
      than good.

05/01/00 - V6.16
  IDE/Compiler
    - Release of Code Compressor optimizer for the PRO version.
    - now generate calls to perform 8 bit multiply/divide/shift as
      appropriate
  IDE/Compiler/Library
    - Added Project->Options->Target->"Strings in FLASH Only" to
      allocate "strings" in FLASH only. Compiler flag is
      -Wf-str_in_flash. Added cprintf to support "const char *"
      as the first argument (i.e. the format string).
  Compiler/Library
    - FULL support for enhanced mega devices with inline MUL instructions.
  Library
    - faster/shorter replacement for int/long to FP conversion
      functions.

04/09/00 - V6.15C
  Compiler
    - calling a function returning long w/o assigning its value was broken
  Asm/Linker
    - symbol length increased to 64 chars to accomodate long function names
  Debugging Support
    - a number of COFF related debugging issues have been resolved,
      including source code in header file error.

03/20/00 - V6.15B
    - minor packaging changes
    - added clock.c clock.prj in examples.prj directory
03/13/00 - V6.15a
    - temporarily disabling byte registers since it causes problems

03/11/00 - V6.15
  Compiler
    - debug generation for filenames with exactly 14 (or multiple)
      charcaters were broken
    - the global register allocator now uses both odd and even
      registers allowing more byte variables to go into registers.
    - complete and transparent support in IDE and startup code for
      external 32K/64K SRAM.
  Assembler
    - fixed all known bugs with macro processing
  Library
    - printf %f now works correctly for all values
    - added printf %S for printing "const char *", and functions
      cstrlen(const char *), cstrcpy(char *, const char *), and 
      cstrcmp(const char *, char *) for const char * support.
      These functions' prototypes are in <strings.h>
    - long to FP conversion was broken for longs with the high byte
      non zero
    - faster conversion code from FP to long
    - added atof
  Examples
    - added uartintr.c and uartpolled in \icc\examples.avr directory

02/18/00 - V6.14D
  Compiler
    - typos caused (byte >> 4) to generate incorrect code.
    
02/16/00 - V6.14C
  Compiler
    - calling a function with multiple arguments being function calls generated
      incorrect code.
    - expression of the form "int = int - long" generated incorrect code
    - fixed more right shifting of byte variable errors
    - eeprom.h was left out of the package

02/09/00 - V6.14B
  IDE
    - editor key assignments and code templates are now saved correctly
      (registered version only).

02/01/00 - V6.14a
  Compiler
    - right shifting an unsigned byte (register) variable in an expression
      generated incorrect arithmetic right shift
    - dereferencing an integer casted to a pointer caused compiler
      internal error

01/26/00 - V6.14
  IDE
    - It's now possible to select generation both COFF and HEX output
      file generation
  Compiler
    - Added optimization to remove redundant loads of external variables
      (lds ops). This optimization is not done for Volatile variables.
    - added optimization to perform int operations on long expressions
      if the result is int size only
    - fetching of long const array elements were incorrect
01/20/00 - V6.13e
  IDE
    - output directory was not working correctly under Project->Options
    - error jump to offending line was broken
  Compiler
    - more AVR Studio bug fixes

01/17/00 - V6.13d
  Compiler
    - inline code for long >>1 was incorrect

01/12/00 - V6.13c
  Compiler
    - some problems with seeing local variable in AVR Studio have been fixed
    - added more enhanced core support, lpm Rx,Z
    - incorrect code was generated for the following:
        char x; int y;
        x = 0; y = 0;
  Assembler
    - all new enhanced core instructions are supported

01/07/00 - V6.13b
  Compiler
    - unsigned long << 1 was broken
    - a rare bug with register allocator was fixed

12/28/99 - V6.13a
  IDE/Compiler/Asm
    - supports enhanced core instructions, movw
    - supports AT94K (FPSLIC)
  Compiler
    - fixed a bug with the peepholer optimizer where if you assign 3 constants
      in a row, the last one may be incorrect

12/20/99 - V6.13
  IDE
    - "Configure Tools" and editor code templates are now enabled
      for the Standard version.
  Compiler
    - floating point ops now use less stack space than previously
  Library
    - complete math.h library function support

12/06/99 - V6.12a
  Compiler
    - array indexing with expression index was incorrect (e.g. a[i-1])
    - floating point add with 2 numbers close in magnitude but differing
      in sign was incorrect.
11/26/99 - V6.12
  Debugger
    - much better integration with AVR Studio V3.0. Most debugger
      problems should be fixed. Added array size in data type. Filenames 
      longer than 14
      characters are supported. You need Studio 3.0 Beta of Nov.26 or newer!
  Compiler
    - complex long arithmetic with constants may generate bad code
    - more optimizations, another 3-8% gain.
  Library
    - long modulo (%) with 0 numerator returns incorrect result

11/08/99 - V6.11a
  Compiler
    - some casts that should have been nops (e.g. unsigned long to long)
      were done incorrectly
    - 6.11 generated inefficient code for byte shifts
    - bit-field reference was always done with 2 byte even if the bitfield
      can fit in one byte
  Library
    - due to the aforementioned cast bug, %lu was printing longs
      greater than 32768l incorrectly

10/29/99 - V6.11
  Compiler
    - interrupt handler no longer saves/restores all volatile registers 
      (same as pre-6.10)
    - Complex expressions involving multiple boolean ops caused bad
      register allocation
    - fixed some global register allocation related to spilling registers
    - some FP operations were not working
    - pointer subtraction was done using long arithmetic
  Library
    - large printf was broken
    - added beta %f support - it currently does not work for floats > 100000!
  IDE
    - SaveAs a file to a source file (e.g. with a .c extesnion) did not
      turn on syntax highlighting
    - Doing a "Search Next" on a different editor tab causes confusing
      behaviors

10/11/99 - V6.10D
  Compiler
    - under some conditions, the compiler was generating
        ldd R30,z+?
        ldd R31,z+?
      which is incorrect since Z is updated by the first ldd
    - register saving for interrupt handler was incorrect for some
      handlers
10/8/99 - V6.10c
  Compiler
    - comparing an unsigned variable with a constant (e.g unsigned char uc;
        if (uc > 127) ) generated incorrect branch code.
10/7/99 - V6.10b
  Compiler
    - better code for accessing FLASH using lpm
10/6/99 - V6.10a
  Fixed bugs in the V6.10 release:
  Compiler
    - debug information for register variables were incorrect
    - arithmetic with long literals were incorrect
    - fixed an "out of register" assertion error
  Library
    - routines to save and restore local registers for interrupt
      handlers were using too much Hardware stack space

10/4/99 - V6.10
  Compiler 
    - Major new rewrite of the code generator. Several peephole optimizations
      have been fixed. General code reduction should be between 5-30%.
  Assebmler
    - macro processing is now in the assembler.
  Header Files
    - Switched to use official header files from Atmel for the IO registers.
  Protection Licensing
    - new version of protection software used. Should fix many key floppy
      related problems.

8/06/99 - V6.0.9
  Protection Licensing
    - the licensing library has been patched to fix some problems
      with incorrect behaviors
  Compiler
    - AVR devices have a bug that sbrs,sbrc,sbis,sbic should not be
      followed by a two-word instruction. Otherwise, an interrupt may
      trash the system. Since these instructions are only used by
      the compiler to skip over conditional code, always emit a rjmp
      so only one word is skipped even for the Mega devices.
  Library
    - AVR Studio Terminal IO support was not working correctly for 
      input.
    - Added libcatmega.a and liblpatmega.a for mega specific libraries.
      This should eliminate any rjmp/rcall errors from the libraries
      when compiling for the Mega devices.

8/03/99 - V6.0.8
  Compiler
    - fixed a bug where the optimizer deleted a "lds" incorrectly

7/30/99 - V6.0.7
  Compiler
    - fixed a bug where if the first executable line in a file is a 
      pragma interrupt_handler,
      the compiler would incorrectly generate a "rjmp" instead of "jmp" 
      even if it is compiling for ATMEGA.
    - the compiler was performing 32-bit math when a > 0x7FFF constant
      was used when 16-bit math would be sufficient
    - forgot to add "sbrs" to the optimizer table, and sometimes the
      optimizer would delete a copy incorrectly.

7/26/99 - V6.0.6
  Library
    - added fp2int for floating point to integer conversion

7/23/99 - V6.0.5
  Compiler
    - automatic detecing of referencing IO space. Now generates BSET, BCLR,
      IN, OUT, SBIS, SBIC, SBI, and CBI automatically. Improve code size 
      dramatically for some programs.

      For example:
      SREG = 0x7F;  
      old code: 8 bytes
      new code: 4 bytes
      
7/13/99 - V6.0.4
  ICCAVR PRO Version Preview Release
  There is no longer a need to add \icc\bin to the path

  IDE and make
    - use .lk extension for temp. file instead of .lnk since .lnk is used
      by Explorer to mean shortcut file.
  Assembler
    - cbr was not complementing its operand
  Linker
    - no longer crashes under some circumstances when generating debugging
      information

6/11/99  - V6.0.3
  IDE
    - fixed project builder not to generate a bogus \ in the .lnk file when
      there are many files in the project.
    - now honors the output directroy setting when you perform a CompileTo...
    - set the status window to the first error line after a build
  Compiler
    - fixed assertion on assignment to global long variables
  Assembler
    - added .define directive 
  Library
    - added fp2long library function for converting floating point to long

5/29/99 - V6.0.2
  IDE
    - fixed a typo where the ATMega target was always ON.
  avr.h
    - added more 16-bits register defines.
    
5/27/99 - V6.0.1
  IDE
    - redid the Project Options->Target tab. Add all known AVR devices
      and some new checkboxes.
    - added Help->"View Readme" command.
  Compiler
    - an optimizer bug was causing instructions to get deleted incorrectly.
    - changed to store 16-bits global high byte first, for compatability 
      with IO registers.
  Asm
    - now allow -127..255 as operands for immediate instructions.

5/22/99 - V6.0.0 initial release

