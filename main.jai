/* Jesse Coyle
 * 
 * The Roman Numeral symbols and the value given are split up with two symbols per radix stopping at M (1000)
 * That base 10 radix is represented as an addition or subtractive equation from symbols of that radix and the one radix bigger
 * I - 1
 * V - 5
 * X - 10
 * L - 50
 * C - 100
 * D - 500
 * M - 1000
 * 
 * Example equation:
 *  MMMCMXCIX (3999)
 *   MMM     -    CM   -   XC  -  IX
 *   thousands   hund.    tens   ones
 *   add.        sub.     sub.    sub.
 * [1000 + 1000 + 1000] + [1000 - 100] + [100 - 10] + [10 - 1] = 3999
 *
 * By placing a symbol of lesser value to the left of a greater one on the right, you denote a subtractive behavior.
 * Notice that the radix is the same as the base 10 radix you would use, but also the next radix greater when approaching the latter half (9 and 10) of that radix
 * Also note in 'standard form' that 4 of the same symbol don't occur. Because there is no symbol of 5000 for 1000's radix, we cannot represent 4000 or any number greater.
 * In the event of a 0 such as '101', we omit that radix, the radix symbols preserve unambiguity as 101 = CI
 * If a is the first 1s value radix, b is the second 5s value radix, and c is the third 10s value radix the format of a radix runthrough is as follows:
 *  a - aa - aaa - ab - b - ba - baa - baaa - ac - c
 *  1   2     3    4    5   6     7     8     9    10
 * This pattern is repeated  for each radix, attaching the next radix up to the left as necessary
 * Note that in standard form, in the subtractive case value only requires one look ahead to check for subtractive case
 * 
 * Another form to reduce total glyphs, the greatest glyph contributor is `baaa`, or 8s radix value.
 *  a - aa - aab - ab - b - ba - baa - aac - ac - c
 *  1   2     3    4    5   6     7     8    9    10
 * (I made this program after watching the recent Matt Parker's video)
 * I do note this is still consistent.
 * Also that to check for the subtractive case you must look ahead twice for the 1s value radix symbol
 *
 * There are other forms that I may revisit later, but that's unlikely.
 */

DENOTE_RADIX :: false;

main :: ()
{
    N :: 3999;
    run: int;
    run_start: int;
    max := 6;
    run_max: int;
    run_max_start: int;
    printer: Code : #code print("run: %\n", run);
    for 1..N
    {
        s := int_to_roman(it); // `s` will be free when the program ends :)
        if s.count <= max
        {
            run += 1;
            if run == 1 then run_start = it;
        }
        else if run > 0
        {
            #insert printer;
            if run > run_max
            {
                run_max = run;
                run_max_start = run_start;
            }
            run = 0;
        }
        print("% - %\n", it, s);
    }
    if run > 0
    {
        #insert printer;
        if run > run_max
        {
            run_max = run;
            run_max_start = run_start;
        }
    }
    print("longest run ....%\n", run_max);
    print("  run start ....%\n", run_max_start);
}

int_to_roman :: (_n: int) -> string
{
    n := _n;
    sb: String_Builder;
    defer free_buffers(*sb);
    while n > 0
    {
        radix := radix_place(n);
        t := n/radix;
        t = t%10;
        t = t*radix; // radix place -> radix value
        symbol := radix_to_symbol(t);
        #if DENOTE_RADIX
        {
            print_to_builder(*sb, "[%] ", symbol);
        }
        else
        {
            append(*sb, symbol);
        }
        n -= t;
    }
    return builder_to_string(*sb);
}

// 1  5  10 50 100 500 1000
// I  V  X  L  C   D   M

radix_to_symbol :: (n: int) -> string
{
    if n ==
    {
        case 1;    return "I";
        case 2;    return "II";
        case 3;    return "III";
        case 4;    return "IV";
        case 5;    return "V";
        case 6;    return "VI";
        case 7;    return "VII";
        case 8;    return "VIII"; // IIX
        case 9;    return "IX";
        case 10;   return "X";
        case 20;   return "XX";
        case 30;   return "XXX";
        case 40;   return "XL";
        case 50;   return "L";
        case 60;   return "LX";
        case 70;   return "LXX";
        case 80;   return "LXXX"; // XXC
        case 90;   return "XC";
        case 100;  return "C";
        case 200;  return "CC";
        case 300;  return "CCC";
        case 400;  return "CD";
        case 500;  return "D";
        case 600;  return "DC";
        case 700;  return "DCC";
        case 800;  return "DCCC"; // CCM
        case 900;  return "CM";
        case 1000; return "M";
        case 2000; return "MM";
        case 3000; return "MMM";
        case;      return "?";
    }
}

radix_place :: (n: int) -> int
{
    if n >= 1000 then return 1000;
    if n >= 100  then return 100;
    if n >= 10   then return 10;
    if n >= 1    then return 1;
    return -1; // Negatives?
}

#import "Basic";
