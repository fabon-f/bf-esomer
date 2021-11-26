# Specification

## Syntax

* Unbalanced brackets raise an error.

## Tape

* The tape is bidirectional. Negative index is allowed.
* The tape consists of unsigned 8-bit integers, which can be 0 to 255.
* Every cell of the tape is initialized by 0.
* Index should be in the range of -50000 to 50000. Accessing out of bounds raises an error.
* Each cell of the tape have wrap-around behavior, i.e. `255 + 1` equals to 0, and `0 - 1` equals to 255.

## Input

* When reach the EOF, `,` operator reads 255.
