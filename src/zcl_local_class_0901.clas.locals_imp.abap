*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_ DEFINITION .

  PUBLIC SECTION.
    DATA carrier_id    TYPE c LENGTH 10.
    DATA connection_id TYPE c LENGTH 20.

    CLASS-DATA conn_counter TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_ IMPLEMENTATION.

ENDCLASS.
