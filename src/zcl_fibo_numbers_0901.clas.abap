CLASS zcl_fibo_numbers_0901 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_fibo_numbers_0901 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    CONSTANTS: lc_max_numbers TYPE i VALUE 20.
    DATA: lt_numbers TYPE TABLE OF i,
          lt_output  TYPE TABLE OF string.

    DO lc_max_numbers TIMES.

      CASE sy-index.
        WHEN 1.
          APPEND 0 TO lt_numbers.
        WHEN 2.
          APPEND 1 TO lt_numbers.
        WHEN OTHERS.

          APPEND lt_numbers[ sy-index - 1 ] +
                 lt_numbers[ sy-index - 2 ] TO lt_numbers.
      ENDCASE.
    ENDDO.

    DATA(lv_counter) = 0.
    LOOP AT lt_numbers ASSIGNING FIELD-SYMBOL(<ls_numbers>).
      lv_counter = lv_counter + 1.
      APPEND |{  lv_counter WIDTH = 4 }: { <ls_numbers> WIDTH = 10 ALIGN = RIGHT } | TO lt_output.
    ENDLOOP.

    out->write(
      EXPORTING
        data   = lt_output
        name   = |First { lc_max_numbers } Fibonacci numbers | ).

  ENDMETHOD.
ENDCLASS.
