CLASS lhc_zr_aflight_0901 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Flight
        RESULT result,
      checkCarrid FOR VALIDATE ON SAVE
        IMPORTING keys FOR Flight~checkCarrid.

    METHODS checkSemanticKey FOR VALIDATE ON SAVE
      IMPORTING keys FOR Flight~checkSemanticKey.

    METHODS toFromAirport FOR VALIDATE ON SAVE
      IMPORTING keys FOR Flight~toFromAirport.
    METHODS findDestination FOR DETERMINE ON SAVE
      IMPORTING keys FOR Flight~findDestination.

    METHODS findSource FOR DETERMINE ON SAVE
      IMPORTING keys FOR Flight~findSource.

    METHODS checkCurrency FOR VALIDATE ON SAVE
      IMPORTING keys FOR Flight~checkCurrency.

    METHODS checkPrice FOR VALIDATE ON SAVE
      IMPORTING keys FOR Flight~checkPrice.
ENDCLASS.

CLASS lhc_zr_aflight_0901 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD checkCarrid.

    DATA: lt_read_result TYPE TABLE FOR READ RESULT zr_aflight_0901.
    DATA: lt_carrid TYPE SORTED TABLE OF zcarrid_0901 WITH UNIQUE KEY table_line.

    READ ENTITIES OF zr_aflight_0901 IN LOCAL MODE
        ENTITY Flight
        FIELDS ( carrid )
        WITH CORRESPONDING #( keys )
        RESULT lt_read_result.

    LOOP AT lt_read_result ASSIGNING FIELD-SYMBOL(<ls_read_result>).
      INSERT <ls_read_result>-Carrid INTO TABLE lt_carrid.
    ENDLOOP.

    SELECT carrid
        FROM zr_acarrir_0901
        FOR ALL ENTRIES IN @lt_carrid WHERE
        carrid = @lt_carrid-table_line
        INTO TABLE @DATA(lt_valid_carrid).

    LOOP AT lt_read_result ASSIGNING <ls_read_result>.

      IF NOT line_exists( lt_valid_carrid[ table_line = <ls_read_result>-Carrid ] ).

        DATA(lo_msg) = me->new_message( id = 'ZFLIGHT_RAP'
                                        number = 002
                                        severity = ms-error
                                        v1 = <ls_read_result>-Carrid ).
        APPEND VALUE #( %tky = <ls_read_result>-%tky %msg = lo_msg
                         %element = VALUE #( carrid = if_abap_behv=>mk-on ) ) TO reported-flight.
        APPEND VALUE #( %tky = <ls_read_result>-%tky  ) TO failed-flight.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD checkSemanticKey.

    READ ENTITIES OF zr_aflight_0901 IN LOCAL MODE
         ENTITY Flight
         FIELDS ( carrid connid )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_read_result).

    IF lt_read_result IS NOT INITIAL.
      SELECT carrid, connid
         FROM zr_aflight_0901
         FOR ALL ENTRIES IN @lt_read_result WHERE
         carrid = @lt_read_result-Carrid AND
         connid = @lt_read_result-connid AND
         uuid <> @lt_read_result-%tky-Uuid
         INTO TABLE @DATA(lt_duplicate).

      SELECT carrid, connid
        FROM zaflight_0901_d
        FOR ALL ENTRIES IN @lt_read_result WHERE
        carrid = @lt_read_result-Carrid AND
        connid = @lt_read_result-connid AND
        uuid <> @lt_read_result-Uuid
        APPENDING TABLE @lt_duplicate.
    ENDIF.

    LOOP AT lt_read_result ASSIGNING FIELD-SYMBOL(<ls_read_result>).

      IF line_exists( lt_duplicate[ carrid = <ls_read_result>-Carrid connid = <ls_read_result>-connid ] ).
        DATA(lo_msg) = me->new_message( id = 'ZFLIGHT_RAP' number = 001 severity = ms-error v1 = <ls_read_result>-carrid v2 = <ls_read_result>-Connid ).
        APPEND VALUE #( %tky = <ls_read_result>-%tky %msg = lo_msg
                        %element = VALUE #( carrid  = if_abap_behv=>mk-on airportfrom = if_abap_behv=>mk-on ) ) TO reported-flight.
        APPEND VALUE #( %tky = <ls_read_result>-%tky ) TO failed-flight.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD toFromAirport.

    DATA: lt_read_result TYPE TABLE FOR READ RESULT zr_aflight_0901.

    READ ENTITIES OF zr_aflight_0901 IN LOCAL MODE
        ENTITY Flight
        FIELDS ( AirportFrom AirportTo )
        WITH CORRESPONDING #( keys )
        RESULT lt_read_result.


    LOOP AT lt_read_result ASSIGNING FIELD-SYMBOL(<ls_read_result>).

      IF <ls_read_result>-AirportFrom EQ <ls_read_result>-AirportTo.

        DATA(lo_msg) = me->new_message( id = 'ZFLIGHT_RAP'
                                        number = 003
                                        severity = ms-error ).

        APPEND VALUE #( %tky = <ls_read_result>-%tky %msg = lo_msg
                        %element = VALUE #( airportfrom = if_abap_behv=>mk-on
                                            airportto = if_abap_behv=>mk-on ) ) TO reported-flight.

        APPEND VALUE #( %tky = <ls_read_result>-%tky ) TO failed-flight.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD findDestination.

    DATA: lt_read_result TYPE TABLE FOR READ RESULT zr_aflight_0901,
          lt_modify      TYPE TABLE FOR UPDATE zr_aflight_0901.

    READ ENTITIES OF zr_aflight_0901 IN LOCAL MODE
        ENTITY Flight
        FIELDS ( AirportTo )
        WITH CORRESPONDING #( keys )
        RESULT lt_read_result.

    CHECK lt_read_result IS NOT INITIAL.

    SELECT airport, city, country
        FROM zairports_0901
        FOR ALL ENTRIES IN @lt_read_result WHERE
        airport = @lt_read_result-airportto
        INTO TABLE @DATA(lt_airports).


    LOOP AT lt_read_result ASSIGNING FIELD-SYMBOL(<ls_read_result>).

      DATA(ls_airport) = VALUE #( lt_airports[ airport = <ls_read_result>-airportto ] OPTIONAL ).

      APPEND VALUE #( %tky = <ls_read_result>-%tky countryto = ls_airport-country cityto = ls_airport-city ) TO lt_modify.

    ENDLOOP.

    MODIFY ENTITIES OF zr_aflight_0901 IN LOCAL MODE
        ENTITY Flight
        UPDATE FIELDS ( CountryTo CityTo )
        WITH lt_modify.

  ENDMETHOD.

  METHOD findSource.


    DATA: lt_read_result TYPE TABLE FOR READ RESULT zr_aflight_0901,
          lt_modify      TYPE TABLE FOR UPDATE zr_aflight_0901.

    READ ENTITIES OF zr_aflight_0901 IN LOCAL MODE
        ENTITY Flight
        FIELDS ( AirportFrom )
        WITH CORRESPONDING #( keys )
        RESULT lt_read_result.

    CHECK lt_read_result IS NOT INITIAL.

    SELECT airport, city, country
        FROM zairports_0901
        FOR ALL ENTRIES IN @lt_read_result WHERE
        airport = @lt_read_result-airportfrom
        INTO TABLE @DATA(lt_airports).


    LOOP AT lt_read_result ASSIGNING FIELD-SYMBOL(<ls_read_result>).

      DATA(ls_airport) = VALUE #( lt_airports[ airport = <ls_read_result>-airportfrom ] OPTIONAL ).

      APPEND VALUE #( %tky = <ls_read_result>-%tky countryfrom = ls_airport-country cityfrom = ls_airport-city ) TO lt_modify.

    ENDLOOP.

    MODIFY ENTITIES OF zr_aflight_0901 IN LOCAL MODE
        ENTITY Flight
        UPDATE FIELDS ( Countryfrom Cityfrom )
        WITH lt_modify.

  ENDMETHOD.

  METHOD checkCurrency.

    DATA: lt_read_result TYPE TABLE FOR READ RESULT zr_aflight_0901.

    READ ENTITIES OF zr_aflight_0901 IN LOCAL MODE
        ENTITY Flight
        FIELDS ( Currency )
        WITH CORRESPONDING #( keys )
        RESULT lt_read_result.

    CHECK lt_read_result IS NOT INITIAL.

    SELECT Currency FROM I_Currency
        FOR ALL ENTRIES IN @lt_read_result
        WHERE Currency = @lt_read_result-Currency
            INTO TABLE @DATA(lt_currency).

    LOOP AT lt_read_result ASSIGNING FIELD-SYMBOL(<ls_read_result>).

      IF NOT line_exists( lt_currency[ currency = <ls_read_result>-Currency  ] ).

        DATA(lo_msg) = me->new_message( id = 'ZFLIGHT_RAP' number = 004 severity = ms-error v1 = <ls_read_result>-Currency  ).
        APPEND VALUE #( %tky = <ls_read_result>-%tky %msg = lo_msg
                        %element = VALUE #( currency = if_abap_behv=>mk-on ) ) TO reported-flight.
        APPEND VALUE #( %tky = <ls_read_result>-%tky  ) TO failed-flight.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD checkPrice.

    DATA: lt_read_result TYPE TABLE FOR READ RESULT zr_aflight_0901.

    READ ENTITIES OF zr_aflight_0901 IN LOCAL MODE
        ENTITY Flight
        FIELDS ( Price )
        WITH CORRESPONDING #( keys )
        RESULT lt_read_result.

    LOOP AT lt_read_result ASSIGNING FIELD-SYMBOL(<ls_read_result>).

      IF <ls_read_result>-price <= 0.

        DATA(lo_msg) = me->new_message( id = 'ZFLIGHT_RAP' number = 005 severity = ms-error   ).
        APPEND VALUE #( %tky = <ls_read_result>-%tky %msg = lo_msg
                        %element = VALUE #( price = if_abap_behv=>mk-on ) ) TO reported-flight.
        APPEND VALUE #( %tky = <ls_read_result>-%tky  ) TO failed-flight.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
